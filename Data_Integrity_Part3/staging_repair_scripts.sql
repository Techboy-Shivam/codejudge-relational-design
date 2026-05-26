-- =========================================================================
-- TASK 6: REPAIR SCRIPTS ON STAGING TABLES
-- =========================================================================

-- Create a workspace table for problems
CREATE TABLE stage_problems AS SELECT * FROM problems;

-- Issue 1: Fix negative scores inside staging space
-- BEFORE: SELECT * FROM stage_problems WHERE max_score < 0;
UPDATE stage_problems SET max_score = 0 WHERE max_score < 0;
-- AFTER: SELECT * FROM stage_problems WHERE max_score < 0;

-- Create a workspace table for contests
CREATE TABLE stage_contests AS SELECT * FROM contests;

-- Issue 2: Fix inverted timelines
-- BEFORE: SELECT * FROM stage_contests WHERE end_time <= start_time;
UPDATE stage_contests SET end_time = DATE_ADD(start_time, INTERVAL 3 HOUR) WHERE end_time <= start_time;
-- AFTER: SELECT * FROM stage_contests WHERE end_time <= start_time;
