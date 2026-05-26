-- =========================================================================
-- TASK 3: TRANSACTION SCENARIOS (COMMIT, ROLLBACK, SAVEPOINT)
-- =========================================================================

-- Scenario 1: A student submits a solution and corresponding test results are tracked (COMMIT)
START TRANSACTION;

INSERT INTO submissions (submission_id, student_id, problem_id, source_code, language)
VALUES (1500, 101, 10, 'def solution(): return True', 'Python');

INSERT INTO test_results (submission_id, test_case_id, status, execution_time_ms, memory_used_kb)
VALUES (1500, 1, 'PASSED', 12, 1024),
       (1500, 2, 'PASSED', 15, 1048);

COMMIT;
-- Expected Final State: Submission 1500 and its execution breakdown results are permanently written to the storage log simultaneously, avoiding fragmented entries.

-- Scenario 2: Course enrollment attempted but aborted due to invalid conditions (ROLLBACK)
START TRANSACTION;

INSERT INTO enrollments (student_id, batch_id) VALUES (302, 99);

-- Validation script detects batch_id 99 does not exist, triggering an abort condition
ROLLBACK;
-- Expected Final State: The database instantly sweeps away the tentative entry, leaving student profiles and enrollment records exactly as they were before the transaction started.

-- Scenario 3: Multi-tier point adjustments utilizing SAVEPOINTS (Partial Rollback)
START TRANSACTION;

UPDATE problems SET max_score = 120 WHERE problem_id = 1;
SAVEPOINT first_adjustment;

UPDATE problems SET max_score = -50 WHERE problem_id = 2; -- Erroneous negative value entered

-- System diagnostic detects rule violation, triggering immediate rollback to savepoint
ROLLBACK TO SAVEPOINT first_adjustment;

UPDATE problems SET max_score = 150 WHERE problem_id = 3;

COMMIT;
-- Expected Final State: The updates to Problem 1 and Problem 3 are permanently committed, while the invalid update to Problem 2 is safely discarded.
