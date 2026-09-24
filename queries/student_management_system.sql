/* ============================================================
   STUDENT MANAGEMENT SYSTEM
   ADVANCED SQL IMPLEMENTATION
   ============================================================

   Requirements Covered:
   1. Complex INNER JOIN
   2. Complex OUTER / LEFT JOIN
   3. SELF JOIN
   4. Correlated Subquery
   5. Aggregate Functions
   6. GROUP BY
   7. HAVING
   8. Stored Procedure with Parameters
   9. Trigger
   10. Virtual View 1
   11. Virtual View 2
   12. EXPLAIN Query 1
   13. EXPLAIN ANALYZE Query 1
   14. Composite Index 1
   15. Before / After Indexing
   16. EXPLAIN Query 2
   17. EXPLAIN ANALYZE Query 2
   18. Composite Index 2

   ============================================================ */


DROP DATABASE IF EXISTS student_management_system;
CREATE DATABASE student_management_system;
USE student_management_system;
CREATE TABLE Department (
    DepartmentID VARCHAR(10) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
select * from Department;

CREATE TABLE Faculty (
    FacultyID VARCHAR(10)  PRIMARY KEY,
    FacultyName VARCHAR(100) NOT NULL,
    DepartmentID VARCHAR(10)  NOT NULL,
    CONSTRAINT fk_faculty_department
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
select * from Faculty;

CREATE TABLE Course (
    CourseID VARCHAR(10)  PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID VARCHAR(10)  NOT NULL,
    Credits INT NOT NULL DEFAULT 3 CHECK (Credits BETWEEN 1 AND 6),
    CONSTRAINT fk_course_department
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

select * from Course;

CREATE TABLE Student (
    StudentID VARCHAR(10)  PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    RollNo VARCHAR(20)  NOT NULL UNIQUE,
    PRN VARCHAR(20)  NOT NULL UNIQUE,
    ContactDetails VARCHAR(100) NULL,
    DepartmentID VARCHAR(10)  NOT NULL,
    Semester INT NOT NULL CHECK (Semester BETWEEN 1 AND 8),
    CONSTRAINT fk_student_department
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

select * from Student;

CREATE TABLE Enrollment (
    EnrollmentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID VARCHAR(10) NOT NULL,
    CourseID VARCHAR(10) NOT NULL,
    FacultyID VARCHAR(10) NOT NULL,
    EnrolledOn DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (StudentID) REFERENCES Student(StudentID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_enrollment_faculty
        FOREIGN KEY (FacultyID) REFERENCES Faculty(FacultyID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_enrollment UNIQUE (StudentID, CourseID)
);
select * from enrollment;

CREATE TABLE Examination (
    ExamID INT AUTO_INCREMENT PRIMARY KEY,
    EnrollmentID INT NOT NULL,
    ExamType ENUM('Unit Test 1','Unit Test 2','Unit Test 3','Mid Sem',
                           'End Sem','Practical','Viva','Internal') NOT NULL,
    ExamDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_exam_enrollment
        FOREIGN KEY (EnrollmentID) REFERENCES Enrollment(EnrollmentID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

select * from Examination;

CREATE TABLE attendance (
    attendanceID INT AUTO_INCREMENT PRIMARY KEY,
    ExamID INT NOT NULL UNIQUE,
    attendanceStatus ENUM('Present','Absent','Late','On Duty') NOT NULL DEFAULT 'Present',
    CONSTRAINT fk_attendance_exam
        FOREIGN KEY (ExamID) REFERENCES Examination(ExamID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
drop table attendance;
select * from attendance;

CREATE TABLE Result (
    ResultID       INT AUTO_INCREMENT PRIMARY KEY,
    ExamID         INT NOT NULL UNIQUE,
    Marks          DECIMAL(5,2) NULL CHECK (Marks IS NULL OR Marks BETWEEN 0 AND 100),
    Grade          CHAR(2) NULL,
    ResultStatus   ENUM('Pass','Fail','Pending') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_result_exam
        FOREIGN KEY (ExamID) REFERENCES Examination(ExamID)
        ON DELETE CASCADE ON UPDATE CASCADE
);




/* ============================================================
   STUDENT MANAGEMENT SYSTEM
   ADVANCED SQL QUERIES
   ============================================================ */

USE student_management_system;


-- ============================================================
-- OPERATION 1
-- COMPLEX INNER JOIN
-- ============================================================

SELECT
    s.StudentID,
    s.StudentName,
    d.DepartmentName,
    c.CourseName,
    f.FacultyName,
    e.ExamType,
    r.Marks,
    r.Grade
FROM Student s
INNER JOIN Department d
    ON s.DepartmentID = d.DepartmentID
INNER JOIN Enrollment en
    ON s.StudentID = en.StudentID
INNER JOIN Course c
    ON en.CourseID = c.CourseID
INNER JOIN Faculty f
    ON en.FacultyID = f.FacultyID
INNER JOIN Examination e
    ON en.EnrollmentID = e.EnrollmentID
INNER JOIN Result r
    ON e.ExamID = r.ExamID
ORDER BY s.StudentName;


-- ============================================================
-- OPERATION 2
-- LEFT / OUTER JOIN
-- Show all students even if they have no result
-- ============================================================

SELECT
    s.StudentID,
    s.StudentName,
    d.DepartmentName,
    en.EnrollmentID,
    c.CourseName,
    e.ExamType,
    r.Marks,
    r.ResultStatus
FROM Student s
LEFT JOIN Department d
    ON s.DepartmentID = d.DepartmentID
LEFT JOIN Enrollment en
    ON s.StudentID = en.StudentID
LEFT JOIN Course c
    ON en.CourseID = c.CourseID
LEFT JOIN Examination e
    ON en.EnrollmentID = e.EnrollmentID
LEFT JOIN Result r
    ON e.ExamID = r.ExamID
ORDER BY s.StudentName;


-- ============================================================
-- OPERATION 3
-- SELF JOIN
-- Find students belonging to the same department
-- ============================================================

SELECT
    s1.StudentName AS Student1,
    s2.StudentName AS Student2,
    d.DepartmentName
FROM Student s1
INNER JOIN Student s2
    ON s1.DepartmentID = s2.DepartmentID
    AND s1.StudentID < s2.StudentID
INNER JOIN Department d
    ON s1.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentName;


-- ============================================================
-- OPERATION 4
-- CORRELATED SUBQUERY
-- Students whose marks are greater than their department average
-- ============================================================

SELECT
    s.StudentID,
    s.StudentName,
    d.DepartmentName,
    r.Marks
FROM Student s
INNER JOIN Department d
    ON s.DepartmentID = d.DepartmentID
INNER JOIN Enrollment en
    ON s.StudentID = en.StudentID
INNER JOIN Examination e
    ON en.EnrollmentID = e.EnrollmentID
INNER JOIN Result r
    ON e.ExamID = r.ExamID
WHERE r.Marks >
(
    SELECT AVG(r2.Marks)
    FROM Student s2
    INNER JOIN Enrollment en2
        ON s2.StudentID = en2.StudentID
    INNER JOIN Examination e2
        ON en2.EnrollmentID = e2.EnrollmentID
    INNER JOIN Result r2
        ON e2.ExamID = r2.ExamID
    WHERE s2.DepartmentID = s.DepartmentID
);


-- ============================================================
-- OPERATION 5
-- AGGREGATE FUNCTIONS
-- ============================================================

SELECT
    COUNT(*) AS TotalStudents,
    MIN(Semester) AS MinimumSemester,
    MAX(Semester) AS MaximumSemester,
    AVG(Semester) AS AverageSemester
FROM Student;


-- ============================================================
-- Aggregate marks
-- ============================================================

SELECT
    COUNT(r.ResultID) AS TotalResults,
    MIN(r.Marks) AS MinimumMarks,
    MAX(r.Marks) AS MaximumMarks,
    ROUND(AVG(r.Marks), 2) AS AverageMarks,
    SUM(r.Marks) AS TotalMarks
FROM Result r;


-- ============================================================
-- OPERATION 6
-- GROUP BY
-- Number of students in each department
-- ============================================================

SELECT
    d.DepartmentID,
    d.DepartmentName,
    COUNT(s.StudentID) AS TotalStudents
FROM Department d
LEFT JOIN Student s
    ON d.DepartmentID = s.DepartmentID
GROUP BY
    d.DepartmentID,
    d.DepartmentName
ORDER BY TotalStudents DESC;


-- ============================================================
-- Group marks by course
-- ============================================================

SELECT
    c.CourseID,
    c.CourseName,
    COUNT(r.ResultID) AS TotalResults,
    ROUND(AVG(r.Marks), 2) AS AverageMarks
FROM Course c
INNER JOIN Enrollment en
    ON c.CourseID = en.CourseID
INNER JOIN Examination e
    ON en.EnrollmentID = e.EnrollmentID
INNER JOIN Result r
    ON e.ExamID = r.ExamID
GROUP BY
    c.CourseID,
    c.CourseName;


-- ============================================================
-- OPERATION 7
-- HAVING
-- Departments having more than 2 students
-- ============================================================

SELECT
    d.DepartmentName,
    COUNT(s.StudentID) AS TotalStudents
FROM Department d
INNER JOIN Student s
    ON d.DepartmentID = s.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName
HAVING COUNT(s.StudentID) > 2;


-- ============================================================
-- Courses having average marks greater than 70
-- ============================================================

SELECT
    c.CourseName,
    ROUND(AVG(r.Marks), 2) AS AverageMarks
FROM Course c
INNER JOIN Enrollment en
    ON c.CourseID = en.CourseID
INNER JOIN Examination e
    ON en.EnrollmentID = e.EnrollmentID
INNER JOIN Result r
    ON e.ExamID = r.ExamID
GROUP BY c.CourseID, c.CourseName
HAVING AVG(r.Marks) > 70;


-- ============================================================
-- OPERATION 8
-- STORED PROCEDURE WITH PARAMETER
-- ============================================================

DELIMITER //

CREATE PROCEDURE GetStudentResults(
    IN p_StudentID VARCHAR(10)
)
BEGIN

    SELECT
        s.StudentID,
        s.StudentName,
        c.CourseName,
        e.ExamType,
        e.ExamDate,
        r.Marks,
        r.Grade,
        r.ResultStatus
    FROM Student s
    INNER JOIN Enrollment en
        ON s.StudentID = en.StudentID
    INNER JOIN Course c
        ON en.CourseID = c.CourseID
    INNER JOIN Examination e
        ON en.EnrollmentID = e.EnrollmentID
    LEFT JOIN Result r
        ON e.ExamID = r.ExamID
    WHERE s.StudentID = p_StudentID
    ORDER BY e.ExamDate;

END //

DELIMITER ;


-- Execute procedure
CALL GetStudentResults('S01');


-- ============================================================
-- OPERATION 9
-- TRIGGER
-- Automatically assign grade based on marks
-- ============================================================

DELIMITER //

CREATE TRIGGER before_result_insert
BEFORE INSERT ON Result
FOR EACH ROW
BEGIN

    IF NEW.Marks IS NULL THEN
        SET NEW.Grade = NULL;
        SET NEW.ResultStatus = 'Pending';

    ELSEIF NEW.Marks >= 90 THEN
        SET NEW.Grade = 'A+';
        SET NEW.ResultStatus = 'Pass';

    ELSEIF NEW.Marks >= 80 THEN
        SET NEW.Grade = 'A';
        SET NEW.ResultStatus = 'Pass';

    ELSEIF NEW.Marks >= 70 THEN
        SET NEW.Grade = 'B+';
        SET NEW.ResultStatus = 'Pass';

    ELSEIF NEW.Marks >= 60 THEN
        SET NEW.Grade = 'B';
        SET NEW.ResultStatus = 'Pass';

    ELSEIF NEW.Marks >= 40 THEN
        SET NEW.Grade = 'C';
        SET NEW.ResultStatus = 'Pass';

    ELSE
        SET NEW.Grade = 'F';
        SET NEW.ResultStatus = 'Fail';

    END IF;

END //

DELIMITER ;


-- ============================================================
-- Test trigger
-- ============================================================

-- INSERT INTO Result(ExamID, Marks)
-- VALUES (15, 92);


-- ============================================================
-- OPERATION 10
-- VIRTUAL VIEW 1
-- Student academic performance
-- ============================================================

CREATE OR REPLACE VIEW StudentPerformance AS
SELECT
    s.StudentID,
    s.StudentName,
    d.DepartmentName,
    c.CourseName,
    e.ExamType,
    e.ExamDate,
    r.Marks,
    r.Grade,
    r.ResultStatus
FROM Student s
INNER JOIN Department d
    ON s.DepartmentID = d.DepartmentID
INNER JOIN Enrollment en
    ON s.StudentID = en.StudentID
INNER JOIN Course c
    ON en.CourseID = c.CourseID
INNER JOIN Examination e
    ON en.EnrollmentID = e.EnrollmentID
LEFT JOIN Result r
    ON e.ExamID = r.ExamID;


-- View 1
SELECT *
FROM StudentPerformance;


-- ============================================================
-- OPERATION 11
-- VIRTUAL VIEW 2
-- Department performance
-- ============================================================

CREATE OR REPLACE VIEW DepartmentPerformance AS
SELECT
    d.DepartmentID,
    d.DepartmentName,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    COUNT(r.ResultID) AS TotalResults,
    ROUND(AVG(r.Marks), 2) AS AverageMarks,
    MAX(r.Marks) AS HighestMarks,
    MIN(r.Marks) AS LowestMarks
FROM Department d
LEFT JOIN Student s
    ON d.DepartmentID = s.DepartmentID
LEFT JOIN Enrollment en
    ON s.StudentID = en.StudentID
LEFT JOIN Examination e
    ON en.EnrollmentID = e.EnrollmentID
LEFT JOIN Result r
    ON e.ExamID = r.ExamID
GROUP BY
    d.DepartmentID,
    d.DepartmentName;


-- View 2
SELECT *
FROM DepartmentPerformance;


-- ============================================================
-- OPERATION 12
-- EXPLAIN QUERY 1
-- BEFORE INDEXING
-- ============================================================

EXPLAIN
SELECT
    e.ExamID,
    e.ExamType,
    e.ExamDate,
    en.StudentID
FROM Examination e
INNER JOIN Enrollment en
    ON e.EnrollmentID = en.EnrollmentID
WHERE e.ExamType = 'Mid Sem'
AND e.ExamDate BETWEEN '2026-03-01' AND '2026-03-31';


-- ============================================================
-- OPERATION 13
-- EXPLAIN ANALYZE QUERY 1
-- ============================================================

EXPLAIN ANALYZE
SELECT
    e.ExamID,
    e.ExamType,
    e.ExamDate,
    en.StudentID
FROM Examination e
INNER JOIN Enrollment en
    ON e.EnrollmentID = en.EnrollmentID
WHERE e.ExamType = 'Mid Sem'
AND e.ExamDate BETWEEN '2026-03-01' AND '2026-03-31';


-- ============================================================
-- OPERATION 14
-- COMPOSITE INDEX 1
-- ============================================================

CREATE INDEX idx_exam_type_date
ON Examination(ExamType, ExamDate);


-- ============================================================
-- OPERATION 15
-- AFTER INDEXING
-- ============================================================

EXPLAIN
SELECT
    e.ExamID,
    e.ExamType,
    e.ExamDate,
    en.StudentID
FROM Examination e
INNER JOIN Enrollment en
    ON e.EnrollmentID = en.EnrollmentID
WHERE e.ExamType = 'Mid Sem'
AND e.ExamDate BETWEEN '2026-03-01' AND '2026-03-31';


-- ============================================================
-- EXPLAIN ANALYZE AFTER INDEX
-- ============================================================

EXPLAIN ANALYZE
SELECT
    e.ExamID,
    e.ExamType,
    e.ExamDate,
    en.StudentID
FROM Examination e
INNER JOIN Enrollment en
    ON e.EnrollmentID = en.EnrollmentID
WHERE e.ExamType = 'Mid Sem'
AND e.ExamDate BETWEEN '2026-03-01' AND '2026-03-31';


-- ============================================================
-- OPERATION 16
-- EXPLAIN QUERY 2
-- BEFORE SECOND INDEX
-- ============================================================

EXPLAIN
SELECT
    ResultID,
    ExamID,
    Marks,
    Grade,
    ResultStatus
FROM Result
WHERE ResultStatus = 'Pass'
AND Marks >= 80;


-- ============================================================
-- OPERATION 17
-- EXPLAIN ANALYZE QUERY 2
-- ============================================================

EXPLAIN ANALYZE
SELECT
    ResultID,
    ExamID,
    Marks,
    Grade,
    ResultStatus
FROM Result
WHERE ResultStatus = 'Pass'
AND Marks >= 80;


-- ============================================================
-- OPERATION 18
-- COMPOSITE INDEX 2
-- ============================================================

CREATE INDEX idx_result_status_marks
ON Result(ResultStatus, Marks);


-- ============================================================
-- AFTER SECOND INDEX
-- ============================================================

EXPLAIN
SELECT
    ResultID,
    ExamID,
    Marks,
    Grade,
    ResultStatus
FROM Result
WHERE ResultStatus = 'Pass'
AND Marks >= 80;


-- ============================================================
-- EXPLAIN ANALYZE AFTER SECOND INDEX
-- ============================================================

EXPLAIN ANALYZE
SELECT
    ResultID,
    ExamID,
    Marks,
    Grade,
    ResultStatus
FROM Result
WHERE ResultStatus = 'Pass'
AND Marks >= 80;