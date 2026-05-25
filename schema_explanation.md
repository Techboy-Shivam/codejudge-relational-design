# Raw Data and Schema Understanding

Based on the CodeJudge context, the raw dataset represents an automated coding assessment and grading platform. Below is the conceptual mapping and definition of the dataset components in our own words:

## 1. What Each File/Table Represents
* **Students:** Represents the individual learners or candidates attempting the assessments.
* **Batches & Courses:** Administrative groupings. A Course is the educational module, while a Batch represents a specific cohort of students taking that course over a timeline.
* **Enrollments:** A junction dataset tracking which student belongs to which batch.
* **Problems & Test Cases:** "Problems" are the coding assignments or algorithmic challenges. "Test Cases" represent the hidden inputs and expected outputs used to validate a student's code submission.
* **Contests & Contest-Problem Mappings:** Contests represent timed assessment events (e.g., exams, weekly tests). The Mapping table links problems to contests, as a single problem can appear in multiple tests.
* **Submissions & Test Results:** Core transactional data. A "Submission" records a student's code upload for a problem. "Test Results" capture the execution breakdown of that submission against individual test cases (Pass/Fail, execution time, memory used).
* **Sessions & Attendance:** Tracks student engagement, login times, and daily presence during lectures or labs.
* **Operations/Flags (Plagiarism & Regrades):** Quality control layers. Plagiarism flags catch code similarities, while Regrade Requests track manual overrides or disputes on automated scores.

## 2. Key Identification & Connectivity Columns
* **Identifiers:** Record uniqueness is maintained through dedicated surrogate IDs (`student_id`, `problem_id`, `submission_id`, `contest_id`).
* **Connectivity (Foreign Keys):** Tables connect through these IDs. For example, `submissions` connects to `students` via `student_id` and to `problems` via `problem_id`. `test_results` links directly back to `submission_id`.

## 3. Redundancy and Non-Normalized Patterns in Raw CSVs
* **Flat Operational Logs:** The raw data maps student details alongside every submission or attendance record, causing massive text duplication (e.g., repeating student names or problem statements).
* **Composite Fields:** Situations where test execution summaries or user metadata are jammed into a single string column rather than being broken down.
