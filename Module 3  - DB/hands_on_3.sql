USE college_db;

-- TASK 1

SELECT student_id,
COUNT(*) course_count
FROM enrollments
GROUP BY student_id
HAVING COUNT(*) >
(
    SELECT AVG(course_total)
    FROM
    (
        SELECT COUNT(*) course_total
        FROM enrollments
        GROUP BY student_id
    ) x
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

SELECT *
FROM
(
    SELECT department_id,
    AVG(salary) avg_sal
    FROM professors
    GROUP BY department_id
) x
WHERE avg_sal>85000;

-- TASK 2

CREATE VIEW vw_student_enrollment_summary AS
SELECT
s.student_id,
CONCAT(s.first_name,' ',s.last_name) student_name,
d.dept_name,
COUNT(e.course_id) total_courses,
AVG(
CASE grade
WHEN 'A' THEN 4
WHEN 'B' THEN 3
WHEN 'C' THEN 2
WHEN 'D' THEN 1
WHEN 'F' THEN 0
END
) GPA
FROM students s
LEFT JOIN departments d
ON s.department_id=d.department_id
LEFT JOIN enrollments e
ON s.student_id=e.student_id
GROUP BY s.student_id,student_name,d.dept_name;

CREATE VIEW vw_course_stats AS
SELECT
c.course_name,
c.course_code,
COUNT(e.enrollment_id) total_enrollments,
AVG(
CASE grade
WHEN 'A' THEN 4
WHEN 'B' THEN 3
WHEN 'C' THEN 2
WHEN 'D' THEN 1
WHEN 'F' THEN 0
END
) avg_gpa
FROM courses c
LEFT JOIN enrollments e
ON c.course_id=e.course_id
GROUP BY c.course_id;

SELECT *
FROM vw_student_enrollment_summary
WHERE GPA>3;

DROP VIEW vw_course_stats;
DROP VIEW vw_student_enrollment_summary;

CREATE VIEW vw_student_2022 AS
SELECT *
FROM students
WHERE enrollment_year=2022
WITH CHECK OPTION;

-- TASK 3

DELIMITER $$

CREATE PROCEDURE sp_enroll_student(
IN p_student_id INT,
IN p_course_id INT,
IN p_date DATE
)
BEGIN

IF EXISTS(
SELECT *
FROM enrollments
WHERE student_id=p_student_id
AND course_id=p_course_id
)
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Duplicate Enrollment';
ELSE
INSERT INTO enrollments
(student_id,course_id,enrollment_date)
VALUES
(p_student_id,p_course_id,p_date);
END IF;

END$$

DELIMITER ;

CREATE TABLE department_transfer_log(
log_id INT AUTO_INCREMENT PRIMARY KEY,
student_id INT,
old_department INT,
new_department INT,
transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

START TRANSACTION;

UPDATE students
SET department_id=2
WHERE student_id=1;

INSERT INTO department_transfer_log
(student_id,old_department,new_department)
VALUES
(1,1,2);

COMMIT;

START TRANSACTION;

INSERT INTO enrollments
(student_id,course_id,enrollment_date)
VALUES
(2,2,CURDATE());

SAVEPOINT first_insert;

INSERT INTO enrollments
(student_id,course_id,enrollment_date)
VALUES
(999,999,CURDATE());

ROLLBACK TO first_insert;

COMMIT;