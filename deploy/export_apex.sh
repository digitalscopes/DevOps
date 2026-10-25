#!/usr/bin/env bash
# Exports the APEX app from an environment with SQLcl.
#   split -> apex/source/  (readable per-component files for PR review; run after every approved APEX change)
#   full  -> apex/release/ (single-file install artifact for a release candidate; record its sha256 in the manifest)
#
# Usage: deploy/export_apex.sh deploy/env/dev_uat.env split|full
set -euo pipefail

ENV_FILE=${1:?env file required}
MODE=${2:?split or full}
set -a; source "$ENV_FILE"; set +a
: "${SQLCL_LOGIN:?}" "${APEX_APP_ID:?}"

case "$MODE" in
  split) OPTS="-split -dir apex/source" ;;
  full)  OPTS="-dir apex/release" ;;
  *) echo "mode must be split or full"; exit 1 ;;
esac

# -skipExportDate keeps diffs clean; -expOriginalIds keeps component IDs stable across exports
printf 'apex export -applicationid %s -skipExportDate -expOriginalIds %s\nexit\n' "$APEX_APP_ID" "$OPTS" \
  | sql -S "$SQLCL_LOGIN"

if [ "$MODE" = full ]; then
  sha256sum "apex/release/f$APEX_APP_ID.sql"
fi
