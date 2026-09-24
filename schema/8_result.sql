-- 8. RESULT (marks + grade + outcome per exam)
-- ------------------------------------------------------------
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

-- ------------------------------------------------------------
