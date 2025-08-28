-- azure/05_auditing_and_alerts.sql
-- Enable database auditing to Log Analytics or Storage from the portal ideally.
-- Here we provide audit table and a trigger-based capture as supplemental localaudit (append-only)
-- Local append-only audit table (tight scope)
CREATE TABLE secure.access_audit (
audit_id BIGINT IDENTITY(1,1) PRIMARY KEY,
captured_at DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
principal_name NVARCHAR(256) NULL,
action NVARCHAR(64) NOT NULL,
object_schema NVARCHAR(64) NULL,
object_name NVARCHAR(128) NULL,
statement NVARCHAR(MAX) NULL,
client_ip NVARCHAR(64) NULL
);
-- Example trigger on secure.identities (INSERT/UPDATE/DELETE)
CREATE OR ALTER TRIGGER trg_secure_identities_audit
ON secure.identities
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
SET NOCOUNT ON;
DECLARE @stmt NVARCHAR(MAX) = (SELECT TEXT FROM sys.dm_exec_connections ec
JOIN sys.dm_exec_requests er ON ec.session_id = er.session_id WHERE
ec.session_id = @@SPID FOR XML PATH(''));
INSERT INTO secure.access_audit (principal_name, action, object_schema,
object_name, statement, client_ip)
SELECT ORIGINAL_LOGIN(),
CASE WHEN EXISTS(SELECT 1 FROM inserted) AND EXISTS(SELECT 1 FROM
deleted) THEN 'UPDATE'
WHEN EXISTS(SELECT 1 FROM inserted) THEN 'INSERT'
WHEN EXISTS(SELECT 1 FROM deleted) THEN 'DELETE' END,
'secure', 'identities', @stmt,
CONNECTIONPROPERTY('client_net_address');
END;
