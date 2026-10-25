# One-time environment setup (TEST server only)

DEV/UAT already exists: workspace `DEVOPS-UAT`, schema `DEVOPS-UAT`, app **182 (DevOps)**, APEX 24.2.
Run the rest once, by the PoC lead, in this order:

| Step | Script | Run as | Result |
|---|---|---|---|
| 1 | `01_create_schemas.sql` | DBA (e.g. SYSTEM) | Schema `DEVOPS_PROD` |
| 2 | `02_create_workspaces.sql` | SYS / APEX instance admin | Workspace `DEVOPS-PROD`; users `DEV_A`, `DEV_B`, `RELEASE_MGR` |
| 3 | `db/migrations/V001__create_schema_migrations.sql` | `DEVOPS-UAT` | Migration history table in DEV |
| 4 | `03_baseline_dev.sql` | `DEVOPS-UAT` | Records the existing `PROJECTS` table as V002 (no DDL runs) |
| 5 | First release via `deploy/deploy.sh` | release operator | V001 + V002 run in `DEVOPS_PROD`, app installed in `DEVOPS-PROD` |

Then copy `deploy/env/*.env.template` to `*.env` (git-ignored) and fill in the real values.

Record in `docs/evidence/setup/`: workspace URLs, App IDs (182 in DEV, the PROD ID), APEX and SQLcl versions.

Notes
- `DEVOPS-UAT` contains a hyphen, so in SQL and in the SQLcl login it must be double-quoted: `"DEVOPS-UAT"`.
- DEVOPS-UAT objects live in the APEX-provisioned tablespace. Adjust `define ts = USERS` in step 1 if the test DB uses a different tablespace for DEVOPS_PROD.
