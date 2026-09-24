-- 1. DEPARTMENT
-- ------------------------------------------------------------
CREATE TABLE Department (
    DepartmentID    VARCHAR(10)  PRIMARY KEY,
    DepartmentName  VARCHAR(100) NOT NULL UNIQUE
);

-- ------------------------------------------------------------
