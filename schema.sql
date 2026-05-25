-- SQL DDL Schema for CodeJudge Relational Design

CREATE DATABASE IF NOT EXISTS codejudge_db;
USE codejudge_db;

-- 1. Courses Table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Batches Table
CREATE TABLE batches (
    batch_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    batch_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- 3. Students Table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Enrollments Table (Junction)
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    batch_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, batch_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (batch_id) REFERENCES batches(batch_id) ON DELETE CASCADE
);

-- 5. Problems Table
CREATE TABLE problems (
    problem_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    difficulty_level VARCHAR(50) NOT NULL,
    max_score INT NOT NULL DEFAULT 100,
    CHECK (max_score >= 0)
);

-- 6. Test Cases Table
CREATE TABLE test_cases (
    test_case_id INT AUTO_INCREMENT PRIMARY KEY,
    problem_id INT NOT NULL,
    input_data TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    is_hidden BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

-- 7. Contests Table
CREATE TABLE contests (
    contest_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    CHECK (end_time > start_time)
);

-- 8. Contest-Problem Mapping Table (Junction)
CREATE TABLE contest_problems (
    contest_id INT NOT NULL,
    problem_id INT NOT NULL,
    weightage_points INT NOT NULL DEFAULT 100,
    PRIMARY KEY (contest_id, problem_id),
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

-- 9. Submissions Table
CREATE TABLE submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    problem_id INT NOT NULL,
    contest_id INT DEFAULT NULL, -- Nullable if it's open practice
    source_code TEXT NOT NULL,
    language VARCHAR(50) NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE,
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE SET NULL
);

-- 10. Test Results Table
CREATE TABLE test_results (
    submission_id INT NOT NULL,
    test_case_id INT NOT NULL,
    status VARCHAR(50) NOT NULL, -- e.g., 'PASSED', 'WRONG_ANSWER', 'TLE', 'RTE'
    execution_time_ms INT DEFAULT 0,
    memory_used_kb INT DEFAULT 0,
    PRIMARY KEY (submission_id, test_case_id),
    FOREIGN KEY (submission_id) REFERENCES submissions(submission_id) ON DELETE CASCADE,
    FOREIGN KEY (test_case_id) REFERENCES test_cases(test_case_id) ON DELETE CASCADE
);

-- 11. Sessions Table
CREATE TABLE sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    batch_id INT NOT NULL,
    session_title VARCHAR(255) NOT NULL,
    scheduled_at DATETIME NOT NULL,
    FOREIGN KEY (batch_id) REFERENCES batches(batch_id) ON DELETE CASCADE
);

-- 12. Attendance Table
CREATE TABLE attendance (
    session_id INT NOT NULL,
    student_id INT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ABSENT', -- 'PRESENT', 'ABSENT', 'LATE'
    marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (session_id, student_id),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- 13. Plagiarism Flags Table
CREATE TABLE plagiarism_flags (
    flag_id INT AUTO_INCREMENT PRIMARY KEY,
    submission_id_1 INT NOT NULL,
    submission_id_2 INT NOT NULL,
    similarity_percentage DECIMAL(5,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING', -- 'PENDING', 'CONFIRMED', 'DISMISSED'
    FOREIGN KEY (submission_id_1) REFERENCES submissions(submission_id) ON DELETE CASCADE,
    FOREIGN KEY (submission_id_2) REFERENCES submissions(submission_id) ON DELETE CASCADE,
    CHECK (similarity_percentage BETWEEN 0.00 AND 100.00)
);

-- 14. Regrade Requests Table
CREATE TABLE regrade_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    submission_id INT NOT NULL,
    reason TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'OPEN', -- 'OPEN', 'RESOLVED', 'REJECTED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (submission_id) REFERENCES submissions(submission_id) ON DELETE CASCADE
);
