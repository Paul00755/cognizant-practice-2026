from flask import Blueprint, jsonify, request

courses_bp = Blueprint(
    "courses",
    __name__,
    url_prefix="/api/courses"
)

# Temporary in-memory data
courses = [
    {
        "id": 1,
        "name": "Python Programming",
        "code": "CS101",
        "credits": 4
    }
]


def make_response_json(data, status_code=200):
    return jsonify({
        "status": "success",
        "data": data
    }), status_code


@courses_bp.route("/", methods=["GET"])
def get_courses():
    return make_response_json(courses)


@courses_bp.route("/", methods=["POST"])
def create_course():

    data = request.get_json()

    if data is None:
        return jsonify({"error": "Request must be JSON"}), 400

    required_fields = ["name", "code", "credits"]

    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"{field} is required"}), 400

    data["id"] = len(courses) + 1
    courses.append(data)

    return make_response_json(data, 201)


@courses_bp.route("/<int:course_id>", methods=["GET"])
def get_course(course_id):

    course = next((c for c in courses if c["id"] == course_id), None)

    if course is None:
        return jsonify({"error": "Course not found"}), 404

    return make_response_json(course)


@courses_bp.route("/<int:course_id>", methods=["PUT"])
def update_course(course_id):

    course = next((c for c in courses if c["id"] == course_id), None)

    if course is None:
        return jsonify({"error": "Course not found"}), 404

    data = request.get_json()

    if data is None:
        return jsonify({"error": "Request must be JSON"}), 400

    required_fields = ["name", "code", "credits"]

    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"{field} is required"}), 400

    course["name"] = data["name"]
    course["code"] = data["code"]
    course["credits"] = data["credits"]

    return make_response_json(course)


@courses_bp.route("/<int:course_id>", methods=["DELETE"])
def delete_course(course_id):

    course = next((c for c in courses if c["id"] == course_id), None)

    if course is None:
        return jsonify({"error": "Course not found"}), 404

    courses.remove(course)

    return "", 204