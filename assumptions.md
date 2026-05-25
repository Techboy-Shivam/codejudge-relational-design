# Architectural Schema Assumptions

1. **Standalone Practice vs Contests:** It is assumed that problems can be attempted both inside timed competitive contest configurations or out in an open environment. Thus, `contest_id` within the `submissions` schema is set to allow `NULL` states.
2. **Plagiarism Scope:** Plagiarism calculations comparison pairs are bound globally between matching execution scripts. Structural cascades (`ON DELETE CASCADE`) are placed so deleting a core profile system log purges downstream flag records safely.
3. **Staging Strategy:** To protect production availability against corrupted row records or mismatched datatypes present in dirty input CSV files, standard loading patterns should land raw arrays into flexible unconstrained staging tables before running validation scripts to transform and insert them clean into this 3NF layout.
