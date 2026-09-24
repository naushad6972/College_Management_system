-- 6. EXAMINATION (one exam event per enrollment)
-- ------------------------------------------------------------
CREATE TABLE Examination (
    ExamID           INT AUTO_INCREMENT PRIMARY KEY,
    EnrollmentID     INT NOT NULL,
    ExamType         ENUM('Unit Test 1','Unit Test 2','Unit Test 3','Mid Sem',
                           'End Sem','Practical','Viva','Internal') NOT NULL,
    ExamDate         DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_exam_enrollment
        FOREIGN KEY (EnrollmentID) REFERENCES Enrollment(EnrollmentID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
