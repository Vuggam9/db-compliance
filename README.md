# DB Compliance
Full repository of production-ready SQL and helper scripts for:
- Azure SQL (T-SQL): schemas, RBAC, Always Encrypted setup (Key Vault reference), auditing.
- MySQL: schemas, roles, view-based masking, application-side encryptionhelpers.
Steps:
1. Review `azure/` or `mysql/` for your target platform.
2. Provision Azure Key Vault and grant access to the managed identity/service principal before running Azure scripts.
3. For MySQL encryption, provide `@APP_KEY` securely (use environment/KMS; never commit it).
4. Run `audit/audit_triggers.sql` to enable row-level DDL/DML auditing for PII tables.
5. Use `scripts/migrate_mysql.sh` or `scripts/deploy_azure.ps1` to run the migrations.
Compliance notes:
- Always Encrypted requires client drivers that support it. See `azure/04_always_encrypted_setup.sql` for CEK/CMK creation guidance.
- Dynamic Data Masking (DDM) in Azure is not encryption. Use it only for reducing accidental exposure.
License: Internal use. Do not commit secrets
