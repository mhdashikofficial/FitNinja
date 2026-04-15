from flask import Blueprint, request, jsonify
from flask_mail import Message
from ..extensions import mongo, mail
from ..utils.auth_utils import hash_password, check_password, generate_jwt
import random

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/signup', methods=['POST'])
def signup():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    name = data.get('name')
    age = data.get('age')
    weight = data.get('weight')

    if not all([email, password, name, age, weight]):
        return jsonify({"error": "Missing required fields"}), 400

    if mongo.db.users.find_one({"email": email}):
        return jsonify({"error": "Email already registered"}), 400

    # Generate OTP
    otp = str(random.randint(100000, 999999))
    hashed_pwd = hash_password(password)

    user_data = {
        "email": email,
        "password": hashed_pwd,
        "name": name,
        "age": age,
        "weight": weight,
        "verified": False,
        "otp": otp
    }

    mongo.db.users.insert_one(user_data)

    # Send OTP Email
    try:
        msg = Message("FitNinja - Verify your Email", recipients=[email])
        msg.body = f"Hello {name},\n\nYour verification code is: {otp}\n\nPlease check your spam folder too.\n\nThanks,\nFitNinja Team"
        mail.send(msg)
    except Exception as e:
        print("Mail error:", e)
        return jsonify({"error": "Failed to send email. Please try again."}), 500

    return jsonify({"message": "Signup successful. Please verify your email with the OTP sent."}), 201

@auth_bp.route('/verify-otp', methods=['POST'])
def verify_otp():
    data = request.json
    email = data.get('email')
    otp = data.get('otp')

    user = mongo.db.users.find_one({"email": email})
    if not user:
        return jsonify({"error": "User not found"}), 404

    if str(user.get("otp")) == str(otp):
        mongo.db.users.update_one({"email": email}, {"$set": {"verified": True}, "$unset": {"otp": ""}})
        token = generate_jwt(str(user["_id"]))
        return jsonify({"message": "Verification successful", "token": token}), 200
    
    return jsonify({"error": "Invalid OTP"}), 400

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    user = mongo.db.users.find_one({"email": email})
    if not user:
        return jsonify({"error": "Invalid credentials"}), 401

    if not check_password(password, user['password']):
        return jsonify({"error": "Invalid credentials"}), 401

    if not user.get('verified', False):
        return jsonify({"error": "Please verify your email first"}), 403

    token = generate_jwt(str(user["_id"]))
    # also return if onboarding is completed
    onboarding_completed = user.get("onboarding_completed", False)

    return jsonify({
        "message": "Login successful",
        "token": token,
        "onboarding_completed": onboarding_completed
    }), 200
