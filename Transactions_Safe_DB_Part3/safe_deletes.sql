-- =========================================================================
-- TASK 2: SAFE DELETE OPERATIONS WITH VALIDATION
-- =========================================================================

-- Operation 1: Purging a specific corrupted/empty testing record from a temporary environment
-- SELECT Before
SELECT submission_id, student_id, source_code FROM submissions WHERE submission_id = 999;
-- DELETE query targeting unique record index
DELETE FROM submissions WHERE submission_id = 999;
-- Safety Justification: Utilizing a specific surrogate identifier ensures that no valid production student submissions are modified or stripped from the ledger.

-- Operation 2: Deleting a duplicate link inside an unconstrained staging table
-- SELECT Before
SELECT enrollment_id, student_id, batch_id FROM enrollments WHERE enrollment_id = 442;
-- DELETE query utilizing clear primary key bound
DELETE FROM enrollments WHERE enrollment_id = 442;
-- Safety Justification: By evaluating the unique internal ID rather than broad criteria like `student_id`, we isolate and erase only the redundant duplicate loop row.

-- Architectural Decision Note on Data Correction vs Deletion:
-- In production setups, deleting missing data loops (like an orphaned test case) should be avoided because it destroys historical reporting integrity. It is better architecture to correct anomalies using an UPDATE loop to re-link records to a standard "System Archive Case" placeholder rather than applying catastrophic cascade deletes.
