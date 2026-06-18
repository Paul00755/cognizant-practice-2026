CREATE TABLE departments(
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);

CREATE TABLE students(
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,
    FOREIGN KEY(department_id)
    REFERENCES departments(department_id)
);

CREATE TABLE courses(
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,
    FOREIGN KEY(department_id)
    REFERENCES departments(department_id)
);

CREATE TABLE enrollments(
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),

    FOREIGN KEY(student_id)
    REFERENCES students(student_id),

    FOREIGN KEY(course_id)
    REFERENCES courses(course_id)
);


CREATE TABLE professors(
    professor_id INT AUTO_INCREMENT PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),

    FOREIGN KEY(department_id)
    REFERENCES departments(department_id)
);

-- departments
INSERT INTO departments (dept_name, hod_name, budget) VALUES
 ('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
 ('Electronics', 'Dr. Priya Nair', 620000.00),
 ('Mechanical', 'Dr. Suresh Iyer', 540000.00),
 ('Civil', 'Dr. Ananya Sharma', 430000.00);


INSERT INTO students (first_name, last_name, email, date_of_birth, department_id,
enrollment_year) VALUES
 ('Arjun', 'Mehta', 'arjun.mehta@college.edu', '2003-04-12', 1, 2022),
 ('Priya', 'Suresh', 'priya.suresh@college.edu', '2003-07-25', 1, 2022),
 ('Rohan', 'Verma', 'rohan.verma@college.edu', '2002-11-08', 2, 2021),
 ('Sneha', 'Patel', 'sneha.patel@college.edu', '2004-01-30', 3, 2023),
 ('Vikram', 'Das', 'vikram.das@college.edu', '2003-09-14', 1, 2022),
 ('Kavya', 'Menon', 'kavya.menon@college.edu', '2002-05-17', 2, 2021),
 ('Aditya', 'Singh', 'aditya.singh@college.edu', '2004-03-22', 4, 2023),
 ('Deepika','Rao', 'deepika.rao@college.edu', '2003-08-09', 1, 2022);


INSERT INTO courses (course_name, course_code, credits, department_id) VALUES
 ('Data Structures & Algorithms', 'CS101', 4, 1),
 ('Database Management Systems', 'CS102', 3, 1),
 ('Object Oriented Programming', 'CS103', 4, 1),
 ('Circuit Theory', 'EC101', 3, 2),
 ('Thermodynamics', 'ME101', 3, 3);

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
 (1, 1, '2022-07-01', 'A'), (1, 2, '2022-07-01', 'B'),
 (2, 1, '2022-07-01', 'B'), (2, 3, '2022-07-01', 'A'),
 (3, 4, '2021-07-01', 'A'), (4, 5, '2023-07-01', NULL),
 (5, 1, '2022-07-01', 'C'), (5, 2, '2022-07-01', 'A'),
 (6, 4, '2021-07-01', 'B'), (7, 5, '2023-07-01', NULL),
 (8, 1, '2022-07-01', 'A'), (8, 3, '2022-07-01', 'B');
 
 INSERT INTO professors (prof_name, email, department_id, salary) VALUES
 ('Dr. Anand Krishnan', 'anand.k@college.edu', 1, 95000.00),
 ('Dr. Meena Pillai', 'meena.p@college.edu', 1, 88000.00),
 ('Dr. Sunil Rajan', 'sunil.r@college.edu', 2, 82000.00),
 ('Dr. Latha Gopal', 'latha.g@college.edu', 3, 79000.00),
 ('Dr. Kartik Bose', 'kartik.b@college.edu', 4, 76000.00);
 
 ALTER TABLE students ADD phone_number VARCHAR(15);

desc students;

ALTER TABLE courses ADD max_seats INT DEFAULT 60;

ALTER TABLE enrollments ADD CONSTRAINT chk_grade CHECK (grade IN ('A','B','C','D','F') OR grade IS NULL);

desc enrollments;
select *  from enrollments;

INSERT INTO enrollments (student_id,course_id,enrollment_date,grade) VALUES (1,1,CURDATE(),'X');

ALTER TABLE departments RENAME COLUMN hod_name TO head_of_dept;
DESC departments;

ALTER TABLE students DROP COLUMN phone_number;
desc students;

-- hands on 2

INSERT INTO students
(first_name,last_name,email,date_of_birth,department_id,enrollment_year)
VALUES
('Rahul','Kumar','rahul.kumar@college.edu','2004-06-10',1,2023),
('Neha','Sharma','neha.sharma@college.edu','2003-11-20',2,2022);

UPDATE enrollments SET grade='B' WHERE student_id=5 AND course_id=1;
SELECT * FROM enrollments WHERE grade IS NULL;

set sql_safe_updates=0;
DELETE FROM enrollments WHERE grade IS NULL;

SELECT COUNT(*) AS total_students FROM students;
SELECT COUNT(*) AS total_enrollments FROM enrollments;

SELECT * FROM students WHERE enrollment_year=2022 ORDER BY last_name ASC;
SELECT * FROM courses WHERE credits > 3 ORDER BY credits DESC;

SELECT * FROM professors WHERE salary BETWEEN 80000 AND 95000;
SELECT * FROM students WHERE email LIKE '%@college.edu';

SELECT enrollment_year, COUNT(*) AS total_students FROM students GROUP BY enrollment_year;

-- joins

SELECT CONCAT(s.first_name,' ',s.last_name) AS student_name, d.dept_name
FROM students s INNER JOIN departments d ON s.department_id=d.department_id;

SELECT e.enrollment_id, CONCAT(s.first_name,' ',s.last_name) AS student_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON e.student_id=s.student_id JOIN courses c ON e.course_id=c.course_id;

SELECT d.dept_name,
       ROUND(AVG(p.salary),2) AS avg_salary
FROM departments d
LEFT JOIN professors p
ON d.department_id=p.department_id
GROUP BY d.dept_name;

SELECT dept_name, budget FROM departments WHERE budget > 600000;

SELECT s.student_id,
       s.first_name,
       s.last_name,
       COUNT(e.course_id) AS total_courses
FROM students s
JOIN enrollments e
ON s.student_id=e.student_id
GROUP BY s.student_id,s.first_name,s.last_name
HAVING COUNT(e.course_id) >
(
    SELECT AVG(course_count)
    FROM
    (
        SELECT COUNT(*) AS course_count
        FROM enrollments
        GROUP BY student_id
    ) avg_table
);

SELECT c.course_name
FROM courses c
WHERE NOT EXISTS
(
    SELECT *
    FROM enrollments e
    WHERE e.course_id=c.course_id
    AND e.grade<>'A'
);

SELECT p.*
FROM professors p
WHERE salary=
(
    SELECT MAX(salary)
    FROM professors p2
    WHERE p2.department_id=p.department_id
);

SELECT department_id,AVG(salary)
FROM professors
GROUP BY department_id
HAVING AVG(salary)>85000;

CREATE VIEW student_view AS SELECT student_id,first_name,last_name FROM students;
SELECT * FROM student_view;

UPDATE student_view SET first_name='Rahul' WHERE student_id=1;
DROP VIEW student_view;

START TRANSACTION;
UPDATE students
SET department_id=2
WHERE student_id=1;
COMMIT;

START TRANSACTION;
UPDATE students
SET department_id=2
WHERE student_id=1;
ROLLBACK;

START TRANSACTION;
INSERT INTO enrollments
(student_id,course_id)
VALUES(1,5);
SAVEPOINT s1;
INSERT INTO enrollments
(student_id,course_id)
VALUES(999,5);
ROLLBACK TO s1;
COMMIT;

EXPLAIN
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id=e.student_id
JOIN courses c
ON c.course_id=e.course_id
WHERE s.enrollment_year=2022;

CREATE INDEX idx_enrollment_year ON students(enrollment_year);

EXPLAIN
SELECT s.first_name,
       s.last_name,
       c.course_name
FROM enrollments e
JOIN students s
ON s.student_id=e.student_id
JOIN courses c
ON c.course_id=e.course_id
WHERE s.enrollment_year=2022;


-- n+1 approach

SELECT e.enrollment_id,
       s.first_name,
       c.course_name
FROM enrollments e
JOIN students s
ON e.student_id=s.student_id
JOIN courses c
ON e.course_id=c.course_id;