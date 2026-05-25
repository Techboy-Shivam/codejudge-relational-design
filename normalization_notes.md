# Normalization Reasoning

## 1. Data Redundancy Examples (Raw CSV Data Issues)
* **Example 1 (Student Data):** The raw submission log repeats `student_name`, `email`, and `batch_name` on every single row. If a student makes 50 submissions, their profile is duplicated 50 times.
* **Example 2 (Problem Details):** The contest execution file lists the full text of `problem_title` and `difficulty_level` across thousands of participant entry logs.
* **Example 3 (Attendance & Session):** The raw daily attendance sheet contains full lecture titles, instructor names, and topics alongside every student's daily check-in flag.

## 2. Structural Separations for Improvement
* **Separation 1 (Test Cases vs Problems):** Moving hidden input/output strings into a dedicated `test_cases` table instead of dumping an array inside the `problems` table keeps the problem catalog lightweight and index-friendly.
* **Separation 2 (Contest Mapping):** Separating the relationship between Contests and Problems into a bridge/junction table (`contest_problems`) permits a flexible many-to-many architecture.

## 3. Functional and Partial Dependencies
* In a raw un-normalized submissions sheet with composite keys like `(student_id, problem_id, submission_timestamp)`, the non-prime attribute `student_name` is only functionally dependent on part of the identifier (`student_id`). This constitutes a **Partial Dependency**, violating **2NF**.
* In an un-normalized batch file, `instructor_email` depends on `instructor_name`, which depends on `batch_id`. This **Transitive Dependency** (`batch_id` -> `instructor_name` -> `instructor_email`) violates **3NF**.

## 4. Final Normalization Status & Trade-offs
The proposed schema is fully normalized up to **3NF**. 
* **Trade-off:** Querying a student's leaderboard score now requires joining `Students`, `Submissions`, and `TestResults` instead of scanning a single flat table. This slightly impacts read speeds but eliminates insertion, deletion, and modification anomalies completely.
