-- 2. FACULTY
-- ------------------------------------------------------------
CREATE TABLE Faculty (
    FacultyID       VARCHAR(10)  PRIMARY KEY,
    FacultyName     VARCHAR(100) NOT NULL,
    DepartmentID    VARCHAR(10)  NOT NULL,
    CONSTRAINT fk_faculty_department
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
