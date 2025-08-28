## azure/01_schema_core.sql
```sql
-- azure/01_schema_core.sql
-- Create core schema and non-sensitive tables
CREATE SCHEMA IF NOT EXISTS core;
CREATE TABLE core.users (
 user_id BIGINT IDENTITY(1,1) PRIMARY KEY,
 username NVARCHAR(100) NOT NULL UNIQUE,
 tenant_id UNIQUEIDENTIFIER NOT NULL,
 created_at DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);
CREATE TABLE core.sessions (
 session_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
 user_id BIGINT NOT NULL,
 started_at DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
 last_seen DATETIME2(3) NULL,
 device_info NVARCHAR(512) NULL,
 CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES
core.users(user_id)
);
-- Non-PII lookup table
CREATE TABLE core.countries (
 iso CHAR(2) PRIMARY KEY,
 name NVARCHAR(128) NOT NULL
);
