# Data Repair Plan & Strategy

## Issue Categories & Action Framework
1. **Orphaned Transactional Logs:** Move rows containing missing foreign keys to an isolated staging area for inspection.
2. **Timeline Anomaly Flags:** Set timeline intervals to a default standard window if dates are inverted.
3. **Domain Out of Bounds:** Update negative scores to 0 or flag for manual verification if weights are critical.

## Specific Dataset-Driven Resolution Examples
* **Example 1 (Student ID: 104):** Enrollment links to missing `batch_id` 99. *Action:* Move to a rejected staging table.
* **Example 2 (Problem ID: 45):** Contains a negative `max_score` of -50. *Action:* Standardize to `0` using a database update.
* **Example 3 (Contest ID: 12):** End time occurs before start time. *Action:* Set end time to exactly 3 hours post-start time.
* **Example 4 (Submission ID: 884):** Contains an empty string in the source code field. *Action:* Delete record as it represents an empty transaction.
* **Example 5 (Student ID: 201):** Duplicate account emails detected. *Action:* Retain the earliest record, merge historical tags, drop duplicates.
* **Example 6 (Enrollment ID: 442):** Duplicate row mapping student to the exact same batch. *Action:* Clean out duplicate record using a safety deletion loop.
* **Example 7 (Test Result ID: sub_90, tc_4):** Execution time reads as a negative value. *Action:* Floor the numeric value to `0`.
* **Example 8 (Submission ID: 1102):** Submitted timestamp precedes the registration date. *Action:* Adjust registration timestamp backwards to match submission time.
