-- =========================================================================
-- TASK 1: SAFE UPDATE OPERATIONS WITH VALIDATION
-- =========================================================================

-- Operation 1: Correcting an invalid/placeholder email structure safely
-- SELECT Before
SELECT student_id, name, email FROM students WHERE student_id = 101;
-- UPDATE with selective Primary Key safety guard
UPDATE students SET email = 'shivam.dev@example.com' WHERE student_id = 101;
-- SELECT After
SELECT student_id, name, email FROM students WHERE student_id = 101;
-- Safety Justification: The WHERE clause utilizes the unique Primary Key constraint (`student_id`), eliminating the risk of accidental multi-row updates across the platform directory.

-- Operation 2: Updating a student's batch following an internal track migration
-- SELECT Before
SELECT enrollment_id, student_id, batch_id FROM enrollments WHERE student_id = 205 AND batch_id = 2;
-- UPDATE with target composite bounds
UPDATE enrollments SET batch_id = 5 WHERE student_id = 205 AND batch_id = 2;
-- SELECT After
SELECT enrollment_id, student_id, batch_id FROM enrollments WHERE student_id = 205 AND batch_id = 5;
-- Safety Justification: Combining the explicit relational pair parameters limits row matching strictly to that specific historical registration record.

-- Operation 3: Fixing an incorrect problem score configuration value
-- SELECT Before
SELECT problem_id, title, max_score FROM problems WHERE problem_id = 45;
-- UPDATE targeting target index
UPDATE problems SET max_score = 100 WHERE problem_id = 45;
-- SELECT After
SELECT problem_id, title, max_score FROM problems WHERE problem_id = 45;
-- Safety Justification: Constraining via `problem_id = 45` isolates modification scope directly to a single challenge definition row.

-- Operation 4: Updating operation request workflow status after validation
-- SELECT Before
SELECT request_id, submission_id, status FROM regrade_requests WHERE request_id = 12;
-- UPDATE modifying target milestone flag
UPDATE regrade_requests SET status = 'RESOLVED' WHERE request_id = 12;
-- SELECT After
SELECT request_id, submission_id, status FROM regrade_requests WHERE request_id = 12;
-- Safety Justification: Relying on the system surrogate key (`request_id`) ensures only the validated transaction request transitions states.
