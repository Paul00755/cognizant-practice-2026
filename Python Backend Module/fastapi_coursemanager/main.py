from typing import Optional

from fastapi import Depends, FastAPI
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database import Base, engine, get_db
from models import Course
from schemas import CourseCreate


app = FastAPI(
    title="Course Management API",
    version="1.0"
)


@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


@app.get("/")
async def root():
    return {"message": "API running"}


@app.post("/api/courses/")
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


@app.get("/api/courses/")
async def get_courses(
    skip: int = 0,
    limit: int = 10,
    department_id: Optional[int] = None,
    db: AsyncSession = Depends(get_db),
):

    stmt = select(Course)

    if department_id is not None:
        stmt = stmt.where(
            Course.department_id == department_id
        )

    stmt = stmt.offset(skip).limit(limit)

    result = await db.execute(stmt)

    return result.scalars().all()


@app.get("/api/courses/{course_id}")
async def get_course(
    course_id: int,
    db: AsyncSession = Depends(get_db),
):

    result = await db.execute(
        select(Course).where(Course.id == course_id)
    )

    return result.scalar_one_or_none()

@app.put("/api/courses/{course_id}")
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
        return {"message": "Course not found"}

    db_course.name = course.name
    db_course.code = course.code
    db_course.credits = course.credits
    db_course.department_id = course.department_id

    await db.commit()
    await db.refresh(db_course)

    return db_course

@app.delete("/api/courses/{course_id}")
async def delete_course(
    course_id: int,
    db: AsyncSession = Depends(get_db),
):
    result = await db.execute(
        select(Course).where(Course.id == course_id)
    )

    db_course = result.scalar_one_or_none()

    if db_course is None:
        return {"message": "Course not found"}

    await db.delete(db_course)
    await db.commit()

    return {"message": "Course deleted"}