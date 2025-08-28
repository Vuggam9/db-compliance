-- mysql/04_masking_views.sql
USE app_secure;
DROP VIEW IF EXISTS v_identities_masked;
CREATE VIEW v_identities_masked AS
SELECT
user_id,
CONCAT(SUBSTRING_INDEX(email, '@', 1), '***@', SUBSTRING_INDEX(email, '@',
-1)) AS email_masked,
CONCAT('***-**-', RIGHT(ssn,4)) AS ssn_masked,
phone,
dob
FROM identities;
-- Grant view access for reporting
GRANT SELECT ON app_secure.v_identities_masked TO 'svc_reporting'@'10.0.0.0/8';
