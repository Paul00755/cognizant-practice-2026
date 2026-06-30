from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

from config import Config

from courses import db
migrate = Migrate()


def create_app():
    app = Flask(__name__)

    app.config.from_object(Config)

    db.init_app(app)
    migrate.init_app(app, db)

    from courses.routes import courses_bp
    app.register_blueprint(courses_bp)

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({"error": "Not Found"}), 404

    @app.errorhandler(500)
    def internal(error):
        return jsonify({"error": "Internal Server Error"}), 500

    return app

app = create_app()

if __name__ == "__main__":
    app.run(debug=True)