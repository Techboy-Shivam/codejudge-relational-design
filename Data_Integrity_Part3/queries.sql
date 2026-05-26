-- =========================================================================
-- CODEJUDGE AUTOMATED GRADING PLATFORM - ASSIGNMENT PART 2 QUERIES
-- =========================================================================

-- -------------------------------------------------------------------------
-- SECTION 1: BASIC RETRIEVAL AND FILTERING
-- -------------------------------------------------------------------------

-- Q1.1: List all active students with student ID, name, email, batch, and admission date.
SELECT s.student_id, s.name, s.email, b.batch_name, e.enrolled_at AS admission_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN batches b ON e.batch_id = b.batch_id;

-- Q1.2: Find students whose email is missing or appears invalid.
SELECT student_id, name, email 
FROM students 
WHERE email IS NULL OR email = '' OR email NOT LIKE '%_@__%.__%';

-- Q1.3: List all problems with difficulty level Easy or Medium.
SELECT problem_id, title, difficulty_level, max_score 
FROM problems 
WHERE difficulty_level IN ('Easy', 'Medium');

-- Q1.4: Display the latest 20 submissions based on submission timestamp.
SELECT submission_id, student_id, problem_id, language, submitted_at 
FROM submissions 
ORDER BY submitted_at DESC 
LIMIT 20;

-- Q1.5: Find submissions where the status is not successful.
SELECT submission_id, student_id, problem_id, language, submitted_at 
FROM submissions 
WHERE submission_id NOT IN (
    SELECT DISTINCT submission_id 
    FROM test_results 
    WHERE status = 'PASSED'
);

-- -------------------------------------------------------------------------
-- SECTION 2: JOINS
-- -------------------------------------------------------------------------

-- Q2.1: Display each submission with student name, problem title, language, status, score, and submitted time.
SELECT sub.submission_id, s.name AS student_name, p.title AS problem_title, 
       sub.language, tr.status, p.max_score, sub.submitted_at
FROM submissions sub
JOIN students s ON sub.student_id = s.student_id
JOIN problems p ON sub.problem_id = p.problem_id
LEFT JOIN test_results tr ON sub.submission_id = tr.submission_id;

-- Q2.2: Display all students and their enrollments, including students who are not enrolled in any course.
SELECT s.student_id, s.name, s.email, b.batch_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN batches b ON e.batch_id = b.batch_id;

-- Q2.3: Display all courses with the number of enrolled students.
SELECT c.course_id, c.course_name, COUNT(e.student_id) AS enrolled_students_count
FROM courses c
LEFT JOIN batches b ON c.course_id = b.course_id
LEFT JOIN enrollments e ON b.batch_id = e.batch_id
GROUP BY c.course_id, c.course_name;

-- Q2.4: Display test-case results for each submission, including problem title and student name.
SELECT tr.submission_id, s.name AS student_name, p.title AS problem_title, 
       tr.test_case_id, tr.status, tr.execution_time_ms
FROM test_results tr
JOIN submissions sub ON tr.submission_id = sub.submission_id
JOIN students s ON sub.student_id = s.student_id
JOIN problems p ON sub.problem_id = p.problem_id;

-- Q2.5: Find students who are enrolled in a course but have not submitted any solution for that course.
SELECT DISTINCT s.student_id, s.name, s.email, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN batches b ON e.batch_id = b.batch_id
JOIN courses c ON b.course_id = c.course_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM submissions sub
    WHERE sub.student_id = s.student_id 
      AND sub.problem_id IN (
          SELECT cp.problem_id 
          FROM contest_problems cp
          JOIN contests con ON cp.contest_id = con.contest_id
          -- Connects assignments linked structurally to the batch environment
      )
);

-- -------------------------------------------------------------------------
-- SECTION 3: AGGREGATION AND HAVING
-- -------------------------------------------------------------------------

-- Q3.1: Count submissions by status.
SELECT status, COUNT(*) AS submission_count 
FROM test_results 
GROUP BY status;

-- Q3.2: Calculate average score per problem.
SELECT p.problem_id, p.title, AVG(p.max_score) AS average_calculated_score
FROM problems p
JOIN submissions sub ON p.problem_id = sub.problem_id
GROUP BY p.problem_id, p.title;

-- Q3.3: Find students with more than a chosen number of submissions (e.g., threshold set to 5).
SELECT s.student_id, s.name, COUNT(sub.submission_id) AS total_submissions
FROM students s
JOIN submissions sub ON s.student_id = sub.student_id
GROUP BY s.student_id, s.name
HAVING COUNT(sub.submission_id) > 5;

-- Q3.4: Find problems where the success rate is below 40%.
SELECT p.problem_id, p.title,
       (COUNT(CASE WHEN tr.status = 'PASSED' THEN 1 END) * 100.0 / COUNT(*)) AS success_rate
FROM problems p
JOIN submissions sub ON p.problem_id = sub.problem_id
JOIN test_results tr ON sub.submission_id = tr.submission_id
GROUP BY p.problem_id, p.title
HAVING (COUNT(CASE WHEN tr.status = 'PASSED' THEN 1 END) * 100.0 / COUNT(*)) < 40.0;

-- Q3.5: Find the top 10 most attempted problems.
SELECT p.problem_id, p.title, COUNT(sub.submission_id) AS attempt_count
FROM problems p
JOIN submissions sub ON p.problem_id = sub.problem_id
GROUP BY p.problem_id, p.title
ORDER BY attempt_count DESC
LIMIT 10;

-- -------------------------------------------------------------------------
-- SECTION 4: SUBQUERIES / SET LOGIC
-- -------------------------------------------------------------------------

-- Q4.1: Find students whose average score is greater than the overall average score.
SELECT s.student_id, s.name, AVG(p.max_score) AS student_avg
FROM students s
JOIN submissions sub ON s.student_id = sub.student_id
JOIN problems p ON sub.problem_id = p.problem_id
GROUP BY s.student_id, s.name
HAVING AVG(p.max_score) > (
    SELECT AVG(p2.max_score) 
    FROM problems p2
    JOIN submissions sub2 ON p2.problem_id = sub2.problem_id
);

-- Q4.2: Find problems that have never been attempted.
SELECT problem_id, title 
FROM problems 
WHERE problem_id NOT IN (SELECT DISTINCT problem_id FROM submissions);

-- Q4.3: Find students who have enrolled but never submitted any solution.
SELECT student_id, name, email 
FROM students 
WHERE student_id IN (SELECT student_id FROM enrollments)
  AND student_id NOT IN (SELECT DISTINCT student_id FROM submissions);

-- Q4.4: Find students who submitted solutions in both Python and Java.
SELECT student_id, name, email 
FROM students 
WHERE student_id IN (SELECT student_id FROM submissions WHERE language = 'Python')
  AND student_id IN (SELECT student_id FROM submissions WHERE language = 'Java');

-- Q4.5: Find the second-highest score for a selected problem (e.g., problem_id = 1).
SELECT MAX(max_score) AS second_highest_score 
FROM problems 
WHERE max_score < (SELECT MAX(max_score) FROM problems WHERE problem_id = 1);
