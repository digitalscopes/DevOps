# Release v0.1.0 — deploy to PROD simulation

| | |
|---|---|
| Date | 2026-10-25, ~15:35–15:50 UTC |
| Operator | a.gaddp (DEVOPS-PROD workspace) via APEX SQL Commands + App Builder Import, driven by Claude in Chrome |
| Authorized by | aHMEDgad0115, acting Release Manager (demo exception, see below) |
| Source | commit `8298364` on `feature/5-project-dates` (contains #1, #3, #5) |
| Target | workspace `DEVOPS-PROD`, schema `DEVOPS-PROD`, app **1182** |
| Artifact | `apex/release/f182_v0.1.0.zip`, sha256 `a62ebd56…f27ad9` (= `apex/source/f182` at `8298364`) |
| Manifest | `deploy/releases/v0.1.0.json` |

## Gate exception

Not met at deploy time, accepted by the acting Release Manager for the PoC demo:
- PRs #2, #4, #6 not reviewed by a second person and not merged to `main`.
- Formal UAT not run (P3_NAME required and the date pickers were not tested end-to-end in DEVOPS-UAT).

Follow-up: review and merge #2 → #4 → #6, then UAT in DEV/UAT and in PROD.

## Preflight findings (read-only)

- Workspace `DEVOPS-PROD` → schema `DEVOPS-PROD` (hyphen; setup scripts had assumed `DEVOPS_PROD`).
- 0 applications. No `poc_schema_migrations`.
- **Drift:** a manually created, empty `PROJECTS` (created 2026-10-25 15:28) with `NAME VARCHAR2(200 CHAR) NOT NULL`,
  versus `VARCHAR2(250 CHAR)` nullable in the repo/DEV.
  Decision: drop the empty table and rebuild from the migrations, so PROD matches the repo exactly.

## Steps

| # | Action | Result |
|---|---|---|
| 1 | `drop table projects` (no PURGE — stays in recycle bin) | Table dropped |
| 2 | V001 `create table poc_schema_migrations` | Table created |
| 3 | V002 `create table projects` | Table created |
| 4 | V003 `alter table projects add (start_date, end_date, projects_dates_ck)` | Table altered |
| 5 | Record V001–V003 with file checksums | 3 rows |
| 6 | App Builder → Import `f182_v0.1.0.zip`; parsing schema DEVOPS-PROD; Change Application ID → 1182 | "Application 1182 successfully installed" |
| 7 | Smoke: app metadata | see below |
| 8 | Smoke: `db/verify/smoke_projects.sql` body | `OK: projects smoke test passed`; PROJECTS rows after = 0 |

## Verification

Database (`DEVOPS-PROD`):

```
MIG  V001 SUCCESS f7b6fb745ff1   MIG V002 SUCCESS 3bd1199bab61   MIG V003 SUCCESS 83b1c5f4bf05
COL  ID NUMBER not null | NAME VARCHAR2(250) null | START_DATE DATE null | END_DATE DATE null
CON  PROJECTS_PK (P), PROJECTS_DATES_CK (C) ENABLED
INVALID objects: 0
```

Application 1182 (`DEVOPS-PROD`, alias `DEVOPS`, Run and Develop):

```
Pages: 0 Global, 1 Home, 2 Projects, 3 Project Details, 9999 Login
Page 3: P3_ID Hidden | P3_NAME Text Field req=Yes | P3_START_DATE Date Picker | P3_END_DATE Date Picker
URL: http://apps.digitalscope-eg.com/ords/r/devops-prod/devops/
```

Not verified: logging in to the PROD app and saving a project through Page 3 (UI test).

## Rollback

- App: delete app 1182 in DEVOPS-PROD (no prior PROD version existed).
- DB (compensating, in reverse): `alter table projects drop constraint projects_dates_ck; alter table projects drop (start_date, end_date);`
  then `drop table projects; drop table poc_schema_migrations;`.
  The original empty manual `PROJECTS` can be restored with `flashback table projects to before drop;` while it is still in the recycle bin.
