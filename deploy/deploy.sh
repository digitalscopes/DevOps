#!/usr/bin/env bash
# Deploys one approved release to one environment, in the blueprint's run order:
#   gate checks -> APEX backup export -> preflight -> migrations -> packages -> invalid objects -> APEX import -> smoke tests
#
# Usage: deploy/deploy.sh deploy/env/prod.env deploy/releases/v0.1.0.json
# Needs: SQLcl (`sql`) and python on PATH. Run from the repository root.
# All output is kept under docs/evidence/<release>/<env>-<timestamp>/.
set -euo pipefail

ENV_FILE=${1:?env file required}
MANIFEST=${2:?release manifest required}
PY=${PYTHON:-python}

set -a; source "$ENV_FILE"; set +a
: "${ENV_NAME:?}" "${SQLCL_LOGIN:?}" "${DB_SCHEMA:?}" "${APEX_WORKSPACE:?}" "${APEX_APP_ID:?}"

m() { "$PY" -c 'import json,sys; d=json.load(open(sys.argv[1]))
for k in sys.argv[2].split("."): d=d[k]
print("\n".join(d) if isinstance(d,list) else d)' "$MANIFEST" "$1"; }

RELEASE=$(m release_id)
LOG_DIR="docs/evidence/$RELEASE/$ENV_NAME-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_DIR/deploy.log") 2>&1
echo "== Deploy $RELEASE to $ENV_NAME ($DB_SCHEMA / $APEX_WORKSPACE / app $APEX_APP_ID) at $(date -Is)"

# Runs SQL in a fresh SQLcl session; any SQL error fails the deploy.
run_sql() { { echo "whenever sqlerror exit failure rollback"; cat; echo "exit"; } | sql -S "$SQLCL_LOGIN"; }

# --- 1. Release gate (manifest) -------------------------------------------------
[ "$(m uat_decision.status)" = "APPROVED" ] || { echo "STOP: UAT decision is not APPROVED"; exit 1; }
if [ "$ENV_NAME" = "PROD_SIM" ]; then
  [ -n "$(m production_authorization.authorized_by)" ] || { echo "STOP: no production authorization"; exit 1; }
  [ "$(m open_hotfixes_backported)" = "True" ] || { echo "STOP: open PROD hotfix not backported"; exit 1; }
fi

APEX_FILE=$(m apex_export.file)
EXPECTED_SHA=$(m apex_export.sha256)
ACTUAL_SHA=$(sha256sum "$APEX_FILE" | cut -d' ' -f1)
[ "$ACTUAL_SHA" = "$EXPECTED_SHA" ] || { echo "STOP: $APEX_FILE checksum $ACTUAL_SHA != manifest $EXPECTED_SHA"; exit 1; }
echo "Gate OK; APEX export checksum verified"

# --- 2. Backup current APEX app (app may not exist on first deploy) -------------
echo "apex export -applicationid $APEX_APP_ID -dir $LOG_DIR/backup" | run_sql \
  || echo "WARN: no existing app $APEX_APP_ID to back up"

# --- 3. Preflight ----------------------------------------------------------------
echo "@deploy/sql/preflight.sql $DB_SCHEMA $(m expected_prior_db_version)" | run_sql

# --- 4. Migrations, in manifest order --------------------------------------------
for f in $(m db_migrations); do
  v=$(basename "$f" | cut -d_ -f1)
  echo "-- applying $f"
  printf '@deploy/sql/migration_guard.sql %s\n@%s\n' "$v" "$f" | run_sql
  echo "update poc_schema_migrations set checksum = '$(sha256sum "$f" | cut -d' ' -f1)' where version = '$v'; commit;" | run_sql
done

# --- 5. Packages (specs before bodies), then invalid-object check ----------------
for f in db/packages/*.pks db/packages/*.pkb; do
  [ -e "$f" ] && echo "@$f" | run_sql
done
echo "@db/verify/verify_invalid_objects.sql" | run_sql

# --- 6. APEX import with explicit target mapping ---------------------------------
run_sql <<SQL
begin
  apex_application_install.set_workspace('$APEX_WORKSPACE');
  apex_application_install.set_application_id($APEX_APP_ID);
  apex_application_install.set_schema('$DB_SCHEMA');
  apex_application_install.generate_offset;
end;
/
@$APEX_FILE
SQL

# --- 7. Smoke tests ------------------------------------------------------------------
for f in db/verify/smoke_*.sql; do
  [ -e "$f" ] && echo "@$f" | run_sql
done
echo "@db/verify/verify_migration_history.sql" | run_sql

echo "== DONE $RELEASE on $ENV_NAME at $(date -Is); commit $(git rev-parse HEAD)"
