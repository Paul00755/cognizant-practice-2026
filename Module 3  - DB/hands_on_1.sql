-- HANDS-ON 1

CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;

-- TASK 1 : CREATE TABLES

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),
    FOREIGN KEY (student_id)
        REFERENCES students(student_id),
    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

CREATE TABLE professors (
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- VERIFY TABLES

SHOW TABLES;

DESC departments;
DESC students;
DESC courses;
DESC enrollments;
DESC professors;

-- TASK 2 : NORMALIZATION ANALYSIS

-- 1NF:
-- All columns contain atomic values.
-- No repeating groups exist.

-- 2NF:
-- All non-key attributes depend on the entire primary key.
-- No partial dependencies exist.

-- 3NF:
-- No transitive dependencies exist.
-- Department information is stored separately.
-- Schema satisfies 3NF.

-- TASK 3 : ALTER TABLE

ALTER TABLE students
ADD phone_number VARCHAR(15);

DESC students;

ALTER TABLE courses
ADD max_seats INT DEFAULT 60;

DESC courses;

ALTER TABLE enrollments
ADD CONSTRAINT chk_grade
CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);

DESC enrollments;

ALTER TABLE departments
RENAME COLUMN hod_name TO head_of_dept;

DESC departments;

ALTER TABLE students
DROP COLUMN phone_number;

DESC students;