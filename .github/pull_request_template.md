## Linked issue
Closes #

## Type
- [ ] Feature
- [ ] Bug
- [ ] Hotfix (backport to DEV/UAT required)

## APEX scope
App ID / pages / Dynamic Actions / components changed:

## DB scope
Migrations (`db/migrations/V###__*.sql`) and objects changed:

## Tests / evidence
- [ ] Split export updated in `apex/source/`
- [ ] `db/verify` checks pass in DEV
- [ ] Before/after screenshots in `docs/evidence/`

## Reviewer checklist
- [ ] Migration is forward-only, versioned, inserts into `poc_schema_migrations`
- [ ] Risky DDL has compensating script / backup plan
- [ ] No credentials or environment-specific values committed
