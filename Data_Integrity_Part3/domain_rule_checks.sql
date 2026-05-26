-- =========================================================================
-- TASK 4: DOMAIN AND RULE VALIDATION
-- =========================================================================

-- 1. Check for negative scores
SELECT problem_id, max_score FROM problems WHERE max_score < 0;

-- 2. Check for invalid difficulty values
SELECT problem_id, difficulty_level FROM problems WHERE difficulty_level NOT IN ('Easy', 'Medium', 'Hard');

-- 3. Check for invalid test result statuses
SELECT submission_id, test_case_id, status FROM test_results 
WHERE status NOT IN ('PASSED', 'WRONG_ANSWER', 'TLE', 'RTE');

-- 4. Check for timeline violations (End time before Start time)
SELECT contest_id, title FROM contests WHERE end_time <= start_time;

-- 5. Check for submission before enrollment date
SELECT sub.submission_id, sub.student_id, sub.submitted_at, e.enrolled_at 
FROM submissions sub
JOIN enrollments e ON sub.student_id = e.student_id
WHERE sub.submitted_at < e.enrolled_at;
