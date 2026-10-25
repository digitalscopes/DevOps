# One-time environment setup (TEST server only)

Run once, by the PoC lead, in this order:

| Step | Script | Run as | Result |
|---|---|---|---|
| 1 | `01_create_schemas.sql` | DBA (e.g. SYSTEM) | Schemas `POC_DEV`, `POC_PROD` |
| 2 | `02_create_workspaces.sql` | SYS / APEX instance admin | Workspaces `POC_DEV_UAT`, `POC_PROD`; users `DEV_A`, `DEV_B`, `RELEASE_MGR` |
| 3 | `db/migrations/V001__create_schema_migrations.sql` | `POC_DEV`, then `POC_PROD` | Migration history table in each schema |

Then copy `deploy/env/*.env.template` to `*.env` (git-ignored) and fill in the real values.

Record in `docs/evidence/setup/`: workspace URLs, App IDs, APEX and SQLcl versions, and the
output of `select workspace, schemas from apex_workspaces where workspace like 'POC%';`.

Adjust `define ts = USERS` in step 1 if the test DB uses a different default tablespace.
