-- azure/02_schema_secure.sql
-- Secure schema for PII and sensitive columns
CREATE SCHEMA IF NOT EXISTS secure;
CREATE TABLE secure.identities (
user_id BIGINT PRIMARY KEY,
email NVARCHAR(256) NULL,
phone NVARCHAR(32) NULL,
ssn CHAR(11) NULL,
dob DATE NULL,
encrypted_blob VARBINARY(MAX) NULL,
created_at DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
CONSTRAINT fk_secure_user FOREIGN KEY (user_id) REFERENCES core.users(user_id)
);
-- Audit events for secure actions
CREATE TABLE secure.audit_events (
audit_id BIGINT IDENTITY(1,1) PRIMARY KEY,
user_id BIGINT NULL,
event_ts DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
actor NVARCHAR(256) NOT NULL,
action NVARCHAR(64) NOT NULL,
object_type NVARCHAR(64) NULL,
object_id NVARCHAR(128) NULL,
details NVARCHAR(MAX) NULL
);
