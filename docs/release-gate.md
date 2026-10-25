# Manual release gate (PoC)

The `digitalscopes` org is on GitHub Free, and rulesets / branch protection are **not enforced on private repositories** on that plan.
Until the org moves to GitHub Team, the controls below replace native protection. The Release Manager owns them.

## Rules for `main`

1. No direct pushes to `main` after the initial scaffold. Every change arrives through a PR.
2. Every PR needs **one approval from someone other than the author** (Developer B reviews Developer A and vice versa; Release Manager reviews hotfixes).
3. **CI - validate** must be green before merge.
4. The PR must link its Issue (`Closes #N`), and the Issue must be on Test Project.
5. Any violation found is recorded in `docs/evidence/` and reported in the PoC results (Risks / limitations).

## Production authorization (PROD_SIM)

A production deploy runs only when **all** of these are true. `deploy/deploy.sh` enforces the manifest checks automatically.

| Check | Where it is recorded | Enforced by |
|---|---|---|
| UAT decision = `APPROVED`, critical defects = 0 | manifest `uat_decision` + UAT Issue comment | `deploy.sh` |
| Release Manager authorized this release ID and SHA | manifest `production_authorization` + Issue comment | `deploy.sh` |
| No PROD hotfix missing from the candidate (Hotfix Register has no `backport-pending`) | manifest `open_hotfixes_backported` | `deploy.sh` + Release Manager |
| Full APEX export checksum matches the manifest | manifest `apex_export.sha256` | `deploy.sh` |
| DB is at the expected prior migration version (no drift) | manifest `expected_prior_db_version` | `deploy/sql/preflight.sql` |
| Release tag `v<version>` points at `source_commit_sha` | Git tag | Release Manager |

## Hotfix gate

If any Issue with label `hotfix` is **not** in status "Merged and tested" for backport, the full release is **BLOCKED**:
reconcile in Page Designer, re-export, re-run UAT, re-approve, then update the manifest.

## When the org moves to GitHub Team

Replace rules 1–3 with a branch ruleset on `main`: require PR, 1 approval, `CI - validate` status check, block force pushes and deletions.
