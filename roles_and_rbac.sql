-- azure/03_roles_and_rbac.sql
-- Create DB roles and map to Azure AD identities (run as Azure SQL admin)
-- Create roles
CREATE ROLE app_reader;
CREATE ROLE app_writer;
CREATE ROLE pii_reader;
CREATE ROLE auditor_role;
-- Grant minimal schema access
GRANT SELECT ON SCHEMA::core TO app_reader;
GRANT SELECT, INSERT, UPDATE ON SCHEMA::core TO app_writer;
-- Secure schema: only auditors and pii_reader may access by default
GRANT SELECT ON SCHEMA::secure TO pii_reader;
GRANT INSERT ON SCHEMA::secure TO app_writer;
GRANT SELECT, INSERT ON SCHEMA::secure.audit_events TO auditor_role;
-- Example: map an AAD group to a role
-- Replace '[AAD\TelemetryAppGroup]' with your AAD group principal
CREATE USER [AAD\TelemetryAppGroup] FROM EXTERNAL PROVIDER;
EXEC sp_addrolemember 'app_reader', 'AAD\TelemetryAppGroup';
-- Create a contained database user for an app managed identity
CREATE USER [app-msi] FROM EXTERNAL PROVIDER;
EXEC sp_addrolemember 'app_writer', 'app-msi';
-- Grant permissions to read Key Vault metadata (not keys) if required
-- Key access is controlled in Key Vault access policies
-- Revoke public access where needed (example)
DENY SELECT ON secure.identities TO public;
