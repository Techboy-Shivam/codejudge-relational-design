# ERD Relationship Diagram (Markdown Text Format)

+------------+        +-------------+        +------------+
|  courses   |1 ----* |   batches   |1 ----* |  sessions  |
+------------+        +-------------+        +------------+
|1                    |1
|                     |
* *
+------------+        +-------------+        +------------+
|  students  |1 ----* | enrollments |        | attendance |
+------------+        +-------------+        +------------+
|1                     ^                      ^
|                      |                      |
|                      | (via student_id)     | (via student_id)
* |                      |
+---------------------------------------------------------+
|                       submissions                       |
+---------------------------------------------------------+
|1              |1                                |1
|               |                                 |
* * *
+-------+   +---------------+                 +---------------+
|contsts|1-|contest_problms|-------1        | plagiarism_flg|
+-------+   +---------------+        |        +---------------+
|
*
+-------------+        +------------+
|  problems   |1 ----* | test_cases |
+-------------+        +------------+
|1
|
*
+------------+
|test_results|
+------------+


### Relationship Key:
* `1 ----*` represents a **One-to-Many** relationship.
* Junction tables (`enrollments`, `contest_proble
