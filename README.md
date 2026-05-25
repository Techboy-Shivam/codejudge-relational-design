# CodeJudge Automated Grading Platform - Relational Design & Schema

This repository contains the complete relational database design, keys configuration, normalization analysis, and SQL schema for an automated coding assessment and grading platform (CodeJudge).

The database architecture has been structured from a raw flat dataset to a fully normalized **3NF (Third Normal Form)** production-ready layout to ensure data integrity, prevent anomalies, and facilitate scalable analytical querying.

---

## 📂 Repository File Structure

The assignment tasks are broken down across the following dedicated files within this repository:

| File Name | Description |
| :--- | :--- |
| **`schema_explanation.md`** | Detailed structural breakdown explaining what each table represents, core connectivity columns, and data redundancy observations from the raw files. |
| **`keys_and_relationships.md`** | Architectural breakdown of system entities, primary keys, candidate/alternate keys, and structural relational mapping logic. |
| **`normalization_notes.md`** | Systematic review identifying data redundancy examples, partial/transitive dependencies, and justification for 3NF target status. |
| **`schema.sql`** | Complete, clean SQL DDL statements with primary/foreign keys, automatic cascading, unique index properties, and business check constraints. |
| **`erd.md`** | A text-based, highly readable Entity-Relationship Diagram detailing table mappings, cardinality definitions, and clear junction configurations. |
| **`assumptions.md`** | Architectural assumptions behind the constraints, open practice handling, plagiarism data boundaries, and safe staging execution strategies. |

---

## 🚀 Key Architectural Highlights

### 1. Robust Constraint Matrix
* **Primary Keys (`PK`):** Auto-incrementing surrogate identifiers are utilized for heavy core tables (`students`, `problems`, `submissions`, `contests`) to preserve indexing speeds.
* **Composite Primary Keys:** Utilized on bridging tables like `test_results` `(submission_id, test_case_id)` and `attendance` `(session_id, student_id)` to handle physical transactional state connections clearly.
* **Domain Validation (`CHECK`):** Defensive constraints enforced directly inside the DBMS layer (e.g., preventing negative scoring structures or validating timeline logic such as `end_time > start_time`).

### 2. Elimination of Anomaly Patterns
The layout resolves standard structural anomalies by extracting duplicate user definitions and flat evaluation descriptions into independent tables:
* **Insertion Anomalies Fixed:** New coding challenges (`problems`) can be added cleanly to the database without needing to wait for live student or submission records.
* **Deletion Anomalies Fixed:** Purging a seasonal test batch doesn't accidentally purge underlying platform problems or historical user profile parameters.
* **Update Anomalies Fixed:** Profile corrections (like a student updating their email) require a single-row update in `students` rather than searching and modifying thousands of records across a flat submission spreadsheet log.

### 3. Data Integrity & Staging Strategy
The DDL layer implements explicit `ON DELETE CASCADE` properties across relational links to handle orphaned records smoothly when rows are cleared. To accommodate contaminated or poorly structured input data within raw CSV bundles, the design assumes records should stream through standard unconstrained intermediate staging configurations before executing validation insert scripts into this clean normalized core schema.
