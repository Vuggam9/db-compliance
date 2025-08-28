-- audit/audit_triggers.sql
-- Cross-platform audit triggers for recording DDL/DML on PII tables. Use these
in addition to platform native auditing.
-- Azure trigger example is provided in azure/05_auditing_and_alerts.sql
(trg_secure_identities_audit).
-- MySQL: create triggers for INSERT/UPDATE/DELETE on app_secure.identities
USE app_secure;
DROP TRIGGER IF EXISTS tr_identities_insert;
DELIMITER $$
CREATE TRIGGER tr_identities_insert AFTER INSERT ON identities
FOR EACH ROW
BEGIN
INSERT INTO audit_events (user_id, actor, action, object_type, object_id,
details)
VALUES (NEW.user_id, CURRENT_USER(), 'INSERT', 'identities', NEW.user_id,
JSON_OBJECT('email', LEFT(NEW.email,30)));
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS tr_identities_update;
DELIMITER $$
CREATE TRIGGER tr_identities_update AFTER UPDATE ON identities
FOR EACH ROW
BEGIN
INSERT INTO audit_events (user_id, actor, action, object_type, object_id,
details)
VALUES (NEW.user_id, CURRENT_USER(), 'UPDATE', 'identities', NEW.user_id,
JSON_OBJECT('changed', 1));
END$$
DELIMITER ;
DROP TRIGGER IF EXISTS tr_identities_delete;
DELIMITER $$
CREATE TRIGGER tr_identities_delete AFTER DELETE ON identities
FOR EACH ROW
BEGIN
INSERT INTO audit_events (user_id, actor, action, object_type, object_id,
details)
VALUES (OLD.user_id, CURRENT_USER(), 'DELETE', 'identities', OLD.user_id,
JSON_OBJECT('deleted', 1));
END$$
DELIMITER ;
