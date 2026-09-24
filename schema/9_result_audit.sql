-- Audit table (used by the auto-grading Trigger in queries.sql)
-- ------------------------------------------------------------
CREATE TABLE Result_Audit (
    AuditID      INT AUTO_INCREMENT PRIMARY KEY,
    ResultID     INT NOT NULL,
    OldStatus    VARCHAR(20),
    NewStatus    VARCHAR(20),
    ChangedOn    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
