# DEVOPS-UAT migration baseline — 2026-10-25

Environment: APEX 24.2.0, workspace `DEVOPS-UAT`, schema `DEVOPS-UAT`, app 182 (DevOps).
Executed by: a.gaddu via APEX SQL Workshop → SQL Commands (run by Claude in Chrome, user signed in).

| Step | Statement | Result |
|---|---|---|
| V001 | `create table poc_schema_migrations (...)` (body of `V001__create_schema_migrations.sql`) | Table created (0.03 s) |
| V001 + V002 | insert V001 row; insert V002 baseline row (`deploy/setup/03_baseline_dev.sql`); commit | Rows inserted |

Pre-existing objects before baseline: `TABLE PROJECTS`, `INDEX PROJECTS_PK`, `SEQUENCE ISEQ$$_212565` (identity), all VALID; `PROJECTS` had 0 rows.

`poc_schema_migrations` after the run:

| VERSION | DESCRIPTION | CHECKSUM | APPLIED_BY | APPLIED_AT | STATUS |
|---|---|---|---|---|---|
| V001 | create schema migrations table | – | APEX_PUBLIC_USER | 2026-10-25 16:56:53 | SUCCESS |
| V002 | baseline projects table (app 182) - pre-existing, recorded only | – | APEX_PUBLIC_USER | 2026-10-25 16:56:53 | SUCCESS |

Notes
- `APPLIED_BY` shows `APEX_PUBLIC_USER` because SQL Commands runs through the ORDS connection pool; runs through `deploy/deploy.sh` (SQLcl) record the schema user.
- `CHECKSUM` is empty for manual runs; `deploy.sh` fills it.
- Next expected DEV migration version: **V003**.
