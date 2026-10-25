# APEX DevOps PoC

Hands-on simulation of an Oracle APEX + GitHub release process (feature release, emergency hotfix, backport, recovery) on the company **test** server only.

## Environments

| Environment | APEX workspace | DB schema | Who changes it |
|---|---|---|---|
| DEV / UAT (sequential) | `POC_DEV_UAT` | `POC_DEV` | Developers; frozen during UAT |
| PROD simulation | `POC_PROD` | `POC_PROD` | Release operator only |

Both schemas may live in the same test database. No customer schemas, credentials, data or integrations.

## Repository layout

| Path | Content / rule |
|---|---|
| `apex/source/` | Split application export (SQLcl) for readable diffs and PR review |
| `apex/release/` | Full application export from the approved UAT snapshot (versioned artifact) |
| `db/migrations/` | Numbered, forward-only scripts: `V###__description.sql` |
| `db/packages/` | Canonical package spec/body, views, triggers |
| `db/verify/` | Schema checks, invalid-object checks, smoke tests |
| `deploy/` | Environment deploy scripts, config templates, release manifest |
| `docs/evidence/` | Screenshots, approvals, before/after results, deploy logs |
| `.github/workflows/` | CI validation and controlled release workflows |

## Branches

- `main` — approved baseline. Changes only through reviewed PRs.
- `feature/<issue-id>-<slug>` — normal development.
- `hotfix/<issue-id>-<slug>` — emergency correction; must be backported to DEV/UAT.
- `release/<version>` + tag `v<version>` — frozen, reviewed, deployable artifact.

## Board workflow

Backlog → In Progress → Code Review → Ready for UAT → UAT Testing → UAT Approved → Ready for PROD → Deployed → Done.
A **Hotfix Register** view filters label `hotfix`.

## Getting started

1. One-time environment setup: [deploy/setup/README.md](deploy/setup/README.md)
2. Export APEX after each approved change: `deploy/export_apex.sh deploy/env/dev_uat.env split`
3. Deploy a release: `deploy/deploy.sh deploy/env/prod.env deploy/releases/<version>.json`
4. Approval rules while branch protection is unavailable: [docs/release-gate.md](docs/release-gate.md)

## Release gate (non-negotiable)

If PROD has any hotfix not included in the approved DEV/UAT candidate, **stop** the full app deploy: reconcile, re-export, re-test, re-approve.

## Deploy run order

1. Preflight (connection, schema, workspace, release version, migration history) — abort on mismatch
2. Prechecks + data backup for risky changes
3. Migrations: additive → backfill → restrictive constraints
4. Compile packages / views / triggers; report `USER_ERRORS` and invalid objects
5. Import approved full APEX export with target workspace / schema / app ID mapping
6. Smoke tests; record version, checksum, logs, approver

Oracle DDL commits implicitly — `ROLLBACK` cannot undo it. Every risky migration needs a compensating script or restore plan.
