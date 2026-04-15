from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv
import os
from .extensions import mongo, mail
from .routes.auth import auth_bp
from .routes.onboarding import onboarding_bp
from .routes.ai_workouts import ai_bp

load_dotenv()

def create_app():
    app = Flask(__name__)
    CORS(app)

    # Config
    app.config["MONGO_URI"] = os.getenv("MONGO_URI")
    app.config["MAIL_SERVER"] = os.getenv("MAIL_SERVER")
    app.config["MAIL_PORT"] = int(os.getenv("MAIL_PORT", 587))
    app.config["MAIL_USE_TLS"] = os.getenv("MAIL_USE_TLS", "True").lower() in ["true", "1"]
    app.config["MAIL_USERNAME"] = os.getenv("MAIL_USERNAME")
    app.config["MAIL_PASSWORD"] = os.getenv("MAIL_PASSWORD")
    app.config["MAIL_DEFAULT_SENDER"] = os.getenv("MAIL_DEFAULT_SENDER")

    # Initialize extensions
    mongo.init_app(app)
    mail.init_app(app)

    # Register blueprints
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(onboarding_bp, url_prefix='/api/onboarding')
    app.register_blueprint(ai_bp, url_prefix='/api/ai')

    @app.route('/')
    def index():
        return "FitNinja API running"

    return app

if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=5000, debug=True)
