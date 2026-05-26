-- =========================================================================
-- TASK 2 & 3: PRIMARY KEY, UNIQUENESS & RELATIONSHIP AUDIT
-- =========================================================================

-- 1. Detect duplicate emails
SELECT email, COUNT(*) FROM students GROUP BY email HAVING COUNT(*) > 1;

-- 2. Detect duplicate enrollments
SELECT student_id, batch_id, COUNT(*) FROM enrollments GROUP BY student_id, batch_id HAVING COUNT(*) > 1;

-- 3. Detect duplicate contest-problem records
SELECT contest_id, problem_id, COUNT(*) FROM contest_problems GROUP BY contest_id, problem_id HAVING COUNT(*) > 1;

-- 4. Orphans: Enrollments linked to missing students
SELECT e.enrollment_id, e.student_id FROM enrollments e 
LEFT JOIN students s ON e.student_id = s.student_id WHERE s.student_id IS NULL;

-- 5. Orphans: Test cases linked to missing problems
SELECT tc.test_case_id, tc.problem_id FROM test_cases tc 
LEFT JOIN problems p ON tc.problem_id = p.problem_id WHERE p.problem_id IS NULL;

-- 6. Orphans: Submissions linked to missing students or problems
SELECT s.submission_id FROM submissions s 
LEFT JOIN students st ON s.student_id = st.student_id 
LEFT JOIN problems p ON s.problem_id = p.problem_id 
WHERE st.student_id IS NULL OR p.problem_id IS NULL;
