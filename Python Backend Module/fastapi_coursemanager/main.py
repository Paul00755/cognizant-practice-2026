from typing import Optional

from fastapi import (
    Depends,
    FastAPI,
    HTTPException,
    Response,
    status,
    BackgroundTasks,
)
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import Base, engine, get_db
from models import Course, Student, Enrollment
from schemas import (
    CourseCreate,
    CourseResponse,
    StudentCreate,
    StudentResponse,
    EnrollmentCreate,
    EnrollmentResponse,
)

app = FastAPI(
    title="Course Management API",
    description="Course Management API using FastAPI",
    version="1.0",
)

@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


@app.get("/")
async def root():
    return {"message": "API running"}


# ---------------------- COURSES ----------------------

@app.post(
    "/api/courses/",
    response_model=CourseResponse,
    status_code=status.HTTP_201_CREATED,
    tags=["Courses"],
    summary="Create a new course",
    response_description="Course created successfully",
)
async def create_course(
    course: CourseCreate,
    db: AsyncSession = Depends(get_db),
):
    new_course = Course(
        name=course.name,
        code=course.code,
        credits=course.credits,
        department_id=course.department_id,
    )

    db.add(new_course)
    await db.commit()
    await db.refresh(new_course)

    return new_course


@app.get(
    "/api/courses/",
    response_model=list[CourseResponse],
    tags=["Courses"],
    summary="Get all courses",
)
async def get_courses(
    skip: int = 0,
    limit: int = 10,
    department_id: Optional[int] = None,
    db: AsyncSession = Depends(get_db),
):
    stmt = select(Course)

    if department_id is not None:
        stmt = stmt.where(Course.department_id == department_id)

    stmt = stmt.offset(skip).limit(limit)

    result = await db.execute(stmt)

    return result.scalars().all()


@app.get(
    "/api/courses/{course_id}",
    response_model=CourseResponse,
    tags=["Courses"],
    summary="Get course by ID",
)
async def get_course(
    course_id: int,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Course).where(Course.id == course_id)
    )

    course = result.scalar_one_or_none()

    if course is None:
        raise HTTPException(
            status_code=404,
            detail="Course not found",
        )

    return course


@app.put(
    "/api/courses/{course_id}",
    response_model=CourseResponse,
    tags=["Courses"],
    summary="Update a course",
)
async def update_course(
    course_id: int,
    course: CourseCreate,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Course).where(Course.id == course_id)
    )

    db_course = result.scalar_one_or_none()

    if db_course is None:
        raise HTTPException(
            status_code=404,
            detail="Course not found",
        )

    db_course.name = course.name
    db_course.code = course.code
    db_course.credits = course.credits
    db_course.department_id = course.department_id

    await db.commit()
    await db.refresh(db_course)

    return db_course


@app.delete(
    "/api/courses/{course_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    tags=["Courses"],
    summary="Delete a course",
)
async def delete_course(
    course_id: int,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Course).where(Course.id == course_id)
    )

    db_course = result.scalar_one_or_none()

    if db_course is None:
        raise HTTPException(
            status_code=404,
            detail="Course not found",
        )

    await db.delete(db_course)
    await db.commit()

    return Response(status_code=status.HTTP_204_NO_CONTENT)


# -------- Step 71 : Students enrolled in a course --------

@app.get(
    "/api/courses/{course_id}/students",
    response_model=list[StudentResponse],
    tags=["Courses"],
    summary="Get students enrolled in a course",
)
async def get_course_students(
    course_id: int,
    db: AsyncSession = Depends(get_db),
):
    stmt = (
        select(Student)
        .join(
            Enrollment,
            Student.id == Enrollment.student_id,
        )
        .where(Enrollment.course_id == course_id)
    )

    result = await db.execute(stmt)

    return result.scalars().all()


# ---------------------- STUDENTS ----------------------

@app.post(
    "/api/students/",
    response_model=StudentResponse,
    status_code=status.HTTP_201_CREATED,
    tags=["Students"],
    summary="Create student",
)
async def create_student(
    student: StudentCreate,
    db: AsyncSession = Depends(get_db),
):
    new_student = Student(**student.dict())

    db.add(new_student)

    await db.commit()
    await db.refresh(new_student)

    return new_student


@app.get(
    "/api/students/",
    response_model=list[StudentResponse],
    tags=["Students"],
    summary="Get all students",
)
async def get_students(
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Student))

    return result.scalars().all()


# ---------------- Background Task ----------------

def send_enrollment_notification(student_id: int):
    print(f"Enrollment notification sent for Student {student_id}")


# ---------------------- ENROLLMENTS ----------------------

@app.post(
    "/api/enrollments/",
    response_model=EnrollmentResponse,
    status_code=status.HTTP_201_CREATED,
    tags=["Enrollments"],
    summary="Create enrollment",
)
async def create_enrollment(
    enrollment: EnrollmentCreate,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
):
    new_enrollment = Enrollment(**enrollment.dict())

    db.add(new_enrollment)

    await db.commit()
    await db.refresh(new_enrollment)

    background_tasks.add_task(
        send_enrollment_notification,
        enrollment.student_id,
    )

    return new_enrollment


@app.get(
    "/api/enrollments/",
    response_model=list[EnrollmentResponse],
    tags=["Enrollments"],
    summary="Get all enrollments",
)
async def get_enrollments(
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(select(Enrollment))

    return result.scalars().all()