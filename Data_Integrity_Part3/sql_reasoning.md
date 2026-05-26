# SQL Architecture & Relational Analytical Reasoning

## 1. LEFT JOIN vs INNER JOIN Application
In **Query 2.2**, a `LEFT JOIN` is required over an `INNER JOIN`. If an `INNER JOIN` were applied between `students` and `enrollments`, any student who recently registered but hasn't been assigned a batch cohort would be completely excluded from the query results. By applying a `LEFT JOIN`, the query preserves the student's primary record and outputs `NULL` values for the missing batch parameters, ensuring complete user visibility.

## 2. HAVING vs WHERE Constraints
In **Query 3.3**, we must isolate users whose total submission counts exceed a specific threshold. A standard `WHERE` clause filtering strategy is invalid here because `WHERE` filters input rows *before* any mathematical grouping or aggregation takes place. To filter metrics calculated via multi-row groupings (`COUNT(submission_id)`), the restriction must be declared within the `HAVING` clause, which processes filters *after* the execution of the `GROUP BY` structural layer.

## 3. Subquery Utility and Logic Isolation
In **Query 4.1**, we isolate students performing above the global average. This problem cannot be solved using a simple linear scan because the global benchmark is dynamic and unknown until calculated. A nested scalar subquery solves this by executing a clean calculation pass over the database first, returning a static baseline value to the outer query's `HAVING` filter.

## 4. Risks of Duplicate Record Errors
When compiling track enrollment numbers (**Query 2.3**), executing a standard `COUNT(student_id)` can lead to misleadingly inflated metrics if a student shifts cohorts or gets recorded twice in the raw history. Without using a explicit `DISTINCT` modifier inside the aggregation execution loop (`COUNT(DISTINCT student_id)`), the query counts duplicate entries as unique participants, throwing off structural capacity and usage analytics.

## 5. Defensive Edge Case Configurations
While designing language intersection logic (**Query 4.4**), a simple equality filter like `WHERE language = 'Python' AND language = 'Java'` will fail because a single transactional string entry cannot match two distinct values simultaneously. To handle this correctly, the architecture isolates separate candidate identification sets via independent `IN` subquery selectors, identifying the valid intersection of users who exist in both tracking logs.
