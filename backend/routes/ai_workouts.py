from flask import Blueprint, request, jsonify
import requests
import os
from ..extensions import mongo
from ..utils.auth_utils import decode_jwt
from bson.objectid import ObjectId
import json

ai_bp = Blueprint('ai', __name__)

def get_current_user_id(req):
    auth_header = req.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return None
    token = auth_header.split(" ")[1]
    decoded = decode_jwt(token)
    if decoded:
        return decoded.get("user_id")
    return None

@ai_bp.route('/generate-plan', methods=['GET'])
def generate_plan():
    user_id = get_current_user_id(request)
    if not user_id:
        return jsonify({"error": "Unauthorized"}), 401

    user = mongo.db.users.find_one({"_id": ObjectId(user_id)})
    if not user:
        return jsonify({"error": "User not found"}), 404

    # Fetch user specifics
    name = user.get("name", "User")
    age = user.get("age", 25)
    weight = user.get("weight", 70)
    equipment = ", ".join(user.get("equipment", []))
    
    nvidia_api_key = os.getenv("NVIDIA_API_KEY")
    nvidia_model = os.getenv("NVIDIA_MODEL")

    prompt = (
        f"Act as a professional physical trainer and boxing coach. "
        f"My name is {name}, I am {age} years old and weigh {weight} kg. "
        f"I have the following equipment at home: {equipment if equipment else 'Bodyweight only'}. "
        "Create a daily plan for me. Provide a JSON response ONLY with the following keys and structure:\n"
        "{\n"
        '  "food_plan": "Describe breakfast, lunch, dinner concisely",\n'
        '  "workout_plan": "Describe the main workout concisely",\n'
        '  "boxing_drills": ["jab cross", "hook uppercut", "jab jab cross slip"]\n'
        "}\n"
        "Do not include any extra thoughts, markdown formatting outside of JSON, or explanation."
    )

    invoke_url = "https://integrate.api.nvidia.com/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {nvidia_api_key}",
        "Accept": "application/json"
    }

    payload = {
        "model": nvidia_model,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 1024,
        "temperature": 0.5,
        "top_p": 1.0,
        "stream": False
    }

    print("Requesting AI plan from NVIDIA API...")
    try:
        response = requests.post(invoke_url, headers=headers, json=payload)
        response.raise_for_status()
        result = response.json()
        content = result['choices'][0]['message']['content']
        
        # Some LLMs wrap JSON in ```json blocks
        if content.startswith("```json"):
            content = content[7:-3]
        elif content.startswith("```"):
            content = content[3:-3]

        parsed_plan = json.loads(content.strip())
        
        return jsonify({"plan": parsed_plan}), 200

    except Exception as e:
        print("AI generation failed:", e)
        # Default fallback plan if API fails
        fallback_plan = {
            "food_plan": "Oatmeal for breakfast, Chicken Salad for lunch, Grilled salmon and veggies for dinner.",
            "workout_plan": "10 min warm up, 20 min HIIT, 10 min shadowing.",
            "boxing_drills": ["jab cross", "jab jab cross", "hook hook uppercut"]
        }
        return jsonify({"plan": fallback_plan, "error": "AI failed, using default."}), 200
