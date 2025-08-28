-- mysql/05_encryption_helpers.sql
-- Application-layer helpers using AES_ENCRYPT / AES_DECRYPT as an example.
-- WARNING: Do not store keys in DB. Use environment variables or KMS and wrapkeys.
-- Example stored function to encrypt using a session variable @APP_KEY (setsecurely in connection)
DROP FUNCTION IF EXISTS encrypt_val;
DELIMITER $$
CREATE FUNCTION encrypt_val(in_plain TEXT) RETURNS BLOB DETERMINISTIC
BEGIN
RETURN AES_ENCRYPT(in_plain, UNHEX(SHA2(@APP_KEY,512)));
END$$
DELIMITER ;
DROP FUNCTION IF EXISTS decrypt_val;
DELIMITER $$
CREATE FUNCTION decrypt_val(in_blob BLOB) RETURNS TEXT
BEGIN
RETURN CONVERT(AES_DECRYPT(in_blob, UNHEX(SHA2(@APP_KEY,512))) USING utf8mb4);
END$$
DELIMITER ;
-- Example usage (do not embed in code; show pattern):
-- SET @APP_KEY = 'my-secret-from-kms';
-- INSERT INTO app_secure.identities (user_id, email, ssn, encrypted_blob)
VALUES (1, AES_ENCRYPT('alice@example.com', UNHEX(SHA2(@APP_KEY,512))),
AES_ENCRYPT('111-22-3333', UNHEX(SHA2(@APP_KEY,512))), NULL);
