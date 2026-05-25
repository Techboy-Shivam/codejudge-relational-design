# Entity and Relationship Identification, Keys, and Constraints

## 1. Main Entities & Table Justification

### A. Students Table
* **Justification:** Holds core static user profiles. Storing names directly inside submissions or attendance logs would cause catastrophic data anomalies.
* **Primary Key:** `student_id` (INT, AUTO_INCREMENT)
* **Constraints:** `email` must be `UNIQUE` and `NOT NULL`.

### B. Problems Table
* **Justification:** Houses the coding challenge text, constraints, and point weights. Separating it ensures problem descriptions aren't duplicated per submission.
* **Primary Key:** `problem_id` (INT, AUTO_INCREMENT)
* **Constraints:** `title` (`NOT NULL`), `max_score` (`CHECK (max_score >= 0)`).

### C. Contests Table
* **Justification:** Manages timed events. Needs separate scheduling properties (`start_time`, `end_time`).
* **Primary Key:** `contest_id` (INT, AUTO_INCREMENT)
* **Constraints:** `CHECK (end_time > start_time)`.

### D. Submissions Table
* **Justification:** Tracks transactional instances of code uploads. A student can submit code to the same problem multiple times.
* **Primary Key:** `submission_id` (INT, AUTO_INCREMENT)
* **Foreign Keys:** `student_id` referencing `Students(student_id)`, `problem_id` referencing `Problems(problem_id)`, `contest_id` referencing `Contests(contest_id)` (nullable if practice submission).

### E. Test Cases Table
* **Justification:** Contains the inputs/outputs used to grade a problem. A single problem contains multiple test cases.
* **Primary Key:** `test_case_id` (INT, AUTO_INCREMENT)
* **Foreign Key:** `problem_id` referencing `Problems(problem_id)`.

### F. Test Results Table
* **Justification:** Tracks the specific pass/fail execution status of a single submission against a specific test case.
* **Primary Key:** Composite Key `(submission_id, test_case_id)`.
* **Foreign Keys:** `submission_id` (Submissions), `test_case_id` (Test Cases).

---

## 2. DBMS Perspective for Constraints
* **NOT NULL:** Enforced on structural foreign keys and essential attributes (e.g., `student_id` in submissions) to prevent orphaned, unidentifiable transactions.
* **UNIQUE:** Applied to `email` fields to prevent account duplication, and composite mappings (like `contest_id` + `problem_id`) to avoid adding the exact same problem to a test twice.
* **CHECK:** Business logic defense (e.g., ensuring score values aren't negative and execution times are positive numbers).
