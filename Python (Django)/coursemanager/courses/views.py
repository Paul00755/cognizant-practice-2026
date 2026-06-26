from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Course, Student, Enrollment
from .serializers import (
    CourseSerializer,
    StudentSerializer,
    EnrollmentSerializer,
)


class CourseViewSet(viewsets.ModelViewSet):
    queryset = Course.objects.all()
    serializer_class = CourseSerializer

@action(detail=True, methods=["get"])
def students(self, request, pk=None):
    course = self.get_object()

    enrollments = Enrollment.objects.filter(course=course)

    student_ids = enrollments.values_list(
        "student_id",
        flat=True
    )

    students = Student.objects.filter(
        id__in=student_ids
    )

    serializer = StudentSerializer(
        students,
        many=True
    )

    return Response(serializer.data)


class StudentViewSet(viewsets.ModelViewSet):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer


class EnrollmentViewSet(viewsets.ModelViewSet):
    queryset = Enrollment.objects.all()
    serializer_class = EnrollmentSerializer