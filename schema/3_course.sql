-- 3. COURSE
-- ------------------------------------------------------------
CREATE TABLE Course (
    CourseID        VARCHAR(10)  PRIMARY KEY,
    CourseName      VARCHAR(100) NOT NULL,
    DepartmentID    VARCHAR(10)  NOT NULL,
    Credits         INT          NOT NULL DEFAULT 3 CHECK (Credits BETWEEN 1 AND 6),
    CONSTRAINT fk_course_department
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
