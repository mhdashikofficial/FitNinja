from flask import Blueprint, request, jsonify
from ..extensions import mongo
from ..utils.auth_utils import decode_jwt
from bson.objectid import ObjectId

onboarding_bp = Blueprint('onboarding', __name__)

def get_current_user_id(req):
    auth_header = req.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return None
    token = auth_header.split(" ")[1]
    decoded = decode_jwt(token)
    if decoded:
        return decoded.get("user_id")
    return None

@onboarding_bp.route('/', methods=['POST'])
def save_onboarding():
    user_id = get_current_user_id(request)
    if not user_id:
        return jsonify({"error": "Unauthorized"}), 401

    data = request.json
    location = data.get('location')
    workout_time = data.get('workout_time')
    equipment = data.get('equipment') # array of strings like ["dumbbells", "gloves"]

    mongo.db.users.update_one(
        {"_id": ObjectId(user_id)},
        {"$set": {
            "location": location,
            "workout_time": workout_time,
            "equipment": equipment,
            "onboarding_completed": True
        }}
    )

    return jsonify({"message": "Onboarding details saved successfully"}), 200
