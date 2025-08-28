#!/usr/bin/env bash
# scripts/migrate_mysql.sh
# Usage: ./migrate_mysql.sh <mysql-host> <mysql-user> <mysql-password>
set -euo pipefail
HOST=${1:-localhost}
USER=${2:-root}
10
PASS=${3:-}
echo "Running MySQL migration against ${HOST} as ${USER}"
mysql -h "$HOST" -u "$USER" -p"$PASS" < mysql/01_schema_core.sql
mysql -h "$HOST" -u "$USER" -p"$PASS" < mysql/02_schema_secure.sql
mysql -h "$HOST" -u "$USER" -p"$PASS" < mysql/03_roles_and_rbac.sql
mysql -h "$HOST" -u "$USER" -p"$PASS" < mysql/04_masking_views.sql
mysql -h "$HOST" -u "$USER" -p"$PASS" < mysql/05_encryption_helpers.sql
mysql -h "$HOST" -u "$USER" -p"$PASS" < audit/audit_triggers.sql
echo "MySQL migration complete. Review logs for errors."
