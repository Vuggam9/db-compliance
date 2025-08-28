-- mysql/03_roles_and_rbac.sql
-- Create roles and grant privileges (MySQL 8+)
CREATE ROLE IF NOT EXISTS 'app_reader';
CREATE ROLE IF NOT EXISTS 'app_writer';
CREATE ROLE IF NOT EXISTS 'pii_reader';
CREATE ROLE IF NOT EXISTS 'auditor_role';
GRANT SELECT ON app_core.* TO 'app_reader';
GRANT SELECT, INSERT, UPDATE ON app_core.* TO 'app_writer';
GRANT SELECT (email, phone) ON app_secure.identities TO 'pii_reader';
GRANT INSERT, SELECT ON app_secure.audit_events TO 'auditor_role';
-- Example service account creation
CREATE USER IF NOT EXISTS 'svc_reporting'@'10.0.0.0/8' IDENTIFIED WITH
mysql_native_password BY '<REPLACE-WITH-STRONG-PASS>';
GRANT 'app_reader' TO 'svc_reporting'@'10.0.0.0/8';
SET DEFAULT ROLE 'app_reader' TO 'svc_reporting'@'10.0.0.0/8';
-- Revoke direct access to base tables for reporting
REVOKE SELECT ON app_secure.identities FROM 'svc_reporting'@'10.0.0.0/8';
