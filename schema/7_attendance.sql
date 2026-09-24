-- 7. ATTENDANCE (one row per exam sitting)
-- ------------------------------------------------------------
CREATE TABLE Attendance (
    AttendanceID     INT AUTO_INCREMENT PRIMARY KEY,
    ExamID           INT NOT NULL UNIQUE,
    AttendanceStatus ENUM('Present','Absent','Late','On Duty') NOT NULL DEFAULT 'Present',
    CONSTRAINT fk_attendance_exam
        FOREIGN KEY (ExamID) REFERENCES Examination(ExamID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
