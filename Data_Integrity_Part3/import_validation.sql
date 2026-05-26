-- =========================================================================
-- TASK 1: ROW COUNT AND IMPORT VALIDATION
-- =========================================================================

-- 1. Row count of each table
SELECT 'students' AS table_name, COUNT(*) AS row_count FROM students
UNION ALL SELECT 'batches', COUNT(*) FROM batches
UNION ALL SELECT 'courses', COUNT(*) FROM courses
UNION ALL SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL SELECT 'problems', COUNT(*) FROM problems
UNION ALL SELECT 'test_cases', COUNT(*) FROM test_cases
UNION ALL SELECT 'contests', COUNT(*) FROM contests
UNION ALL SELECT 'contest_problems', COUNT(*) FROM contest_problems
UNION ALL SELECT 'submissions', COUNT(*) FROM submissions
UNION ALL SELECT 'test_results', COUNT(*) FROM test_results;

-- 2. Number of distinct primary key values in each table
SELECT 'students' AS table_name, COUNT(DISTINCT student_id) AS distinct_pk FROM students
UNION ALL SELECT 'batches', COUNT(DISTINCT batch_id) FROM batches
UNION ALL SELECT 'courses', COUNT(DISTINCT course_id) FROM courses
UNION ALL SELECT 'problems', COUNT(DISTINCT problem_id) FROM problems
UNION ALL SELECT 'contests', COUNT(DISTINCT contest_id) FROM contests
UNION ALL SELECT 'submissions', COUNT(DISTINCT submission_id) FROM submissions;

-- 3. Number of NULL or blank values in important columns
SELECT COUNT(*) AS invalid_emails FROM students WHERE email IS NULL OR email = '';
SELECT COUNT(*) AS invalid_source_code FROM submissions WHERE source_code IS NULL OR source_code = '';
SELECT COUNT(*) AS invalid_test_input FROM test_cases WHERE input_data IS NULL;
