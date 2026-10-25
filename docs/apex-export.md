# Getting APEX changes into GitHub

APEX stores the app in the database, not in files. Every approved change must be **exported** and committed, or Git does not know about it.

## Per change

1. Issue → on the issue page, **Development → Create a branch** named `feature/<issue>-<slug>`
   (this links the branch to the issue; then `git fetch && git checkout feature/<issue>-<slug>`).
2. Make the change in Page Designer (workspace `DEVOPS-UAT`, app 182).
3. Export a **split** export (one of the two ways below) and replace `apex/source/f182/` with it.
4. `git status` — only the pages / components you changed should show as modified.
5. `git add` **only your files** (DEV/UAT is shared: the export also contains other developers' unfinished work), commit with `#<issue>`, push, open a PR.

### Linking and closing rules (GitHub)

- `Closes #<issue>` in the PR description links the PR to the issue and closes it on merge **only when the PR targets `main`** (the default branch).
  A PR stacked on another feature branch must be linked by hand: issue → **Development** → select the PR.
- Board automation (DevOps project → Workflows): PR linked → *In Progress*; PR merged → *Ready for UAT*;
  issue closed → *Done*; only moving an item to *Done* closes the issue.

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
