-- 5. ENROLLMENT (bridge: Student <-> Course <-> Faculty)
-- ------------------------------------------------------------
CREATE TABLE Enrollment (
    EnrollmentID    INT AUTO_INCREMENT PRIMARY KEY,
    StudentID       VARCHAR(10) NOT NULL,
    CourseID        VARCHAR(10) NOT NULL,
    FacultyID       VARCHAR(10) NOT NULL,
    EnrolledOn      DATE NOT NULL DEFAULT (CURRENT_DATE),
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

-- ------------------------------------------------------------
