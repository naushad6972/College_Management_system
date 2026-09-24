-- 4. STUDENT
-- ------------------------------------------------------------
CREATE TABLE Student (
    StudentID       VARCHAR(10)  PRIMARY KEY,
    StudentName     VARCHAR(100) NOT NULL,
    RollNo          VARCHAR(20)  NOT NULL UNIQUE,
    PRN             VARCHAR(20)  NOT NULL UNIQUE,
    ContactDetails  VARCHAR(100) NULL,
    DepartmentID    VARCHAR(10)  NOT NULL,
    Semester        INT          NOT NULL CHECK (Semester BETWEEN 1 AND 8),
    CONSTRAINT fk_student_department
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
