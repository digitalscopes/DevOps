# Getting APEX changes into GitHub

APEX stores the app in the database, not in files. Every approved change must be **exported** and committed, or Git does not know about it.

## Per change

1. Issue → branch `feature/<issue>-<slug>`.
2. Make the change in Page Designer (workspace `DEVOPS-UAT`, app 182).
3. Export a **split** export (one of the two ways below) and replace `apex/source/f182/` with it.
4. `git status` — only the pages / components you changed should show as modified.
5. `git add` **only your files** (DEV/UAT is shared: the export also contains other developers' unfinished work), commit with `#<issue>`, push, open a PR.

## Way A — APEX UI (no tools needed)

App Builder → app 182 → **Export / Import** → **Export** → Next, then set:

| Setting | Value | Why |
|---|---|---|
| Split into Multiple Files | **On** | One file per page/component → readable PR diffs |
| Original IDs | **On** | Component IDs stay stable between exports |
| Audit Information | **None** | No user names / dates → no noise in diffs |
| Readable Format | Off | Keep one format (SQL) in the repo |
| Everything else | default | |

Click **Export** → `f182.zip` downloads → unzip so the result is `apex/source/f182/install.sql`, `apex/source/f182/application/...`.

## Way B — SQLcl (scriptable, same result)

```bash
deploy/export_apex.sh deploy/env/dev_uat.env split
```

Runs `apex export -applicationid 182 -split -skipExportDate -expOriginalIds -dir apex/source`.

## What is in the export

- `install.sql` — runs all files in order (`@@...`); can install the app on its own.
- `application/pages/page_000NN.sql` — one file per page (2 = Projects, 3 = Project Details).
- `application/shared_components/...` — navigation, authentication, themes, files, etc.
- `set_environment.sql` / `create_application.sql` contain the DEV workspace ID and owner `DEVOPS-UAT`.
  `deploy/deploy.sh` overrides them with `apex_application_install` (workspace, app ID, schema) when installing in PROD.

Database objects (tables, packages) are **not** in this export — they live in `db/migrations/` and `db/packages/`.
