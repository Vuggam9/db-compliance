-- azure/04_always_encrypted_setup.sql
-- Guidance and T-SQL artifacts for Always Encrypted. This file does not embedKey Vault credentials.
-- Steps (summarized):
-- 1. Provision an Azure Key Vault and a Key (RSA 2048+). Note its URI.
-- 2. Grant the client/service principal "get" and "unwrapKey" permissions onthe Key Vault key.
-- 3. Register a Column Master Key (CMK) in the database referring to Key Vault.
-- 4. Create Column Encryption Key (CEK) protected by the CMK.
-- 5. Create/alter tables with ENCRYPTED WITH column options.
-- Example: register CMK referencing Azure Key Vault
CREATE COLUMN MASTER KEY MyCMK
WITH (
KEY_STORE_PROVIDER_NAME = 'AZURE_KEY_VAULT',
KEY_PATH = '<YOUR-KEY-VAULT-KEY-URI>' -- e.g. https://<kvname>.vault.azure.net/keys/<key-name>/<key-version>
);
-- Create a Column Encryption Key; the database will use the CMK to protect it.
CREATE COLUMN ENCRYPTION KEY MyCEK
WITH VALUES (
COLUMN_MASTER_KEY = MyCMK,
ALGORITHM = 'RSA_OAEP',
ENCRYPTED_VALUE = 0x0000 -- placeholder: client driver typically creates CEK
);
-- NOTE: Creating CEK often requires client-side tooling (SqlClient) to wrap the
CEK with CMK.
-- Example: alter table to use Always Encrypted on existing column
-- (requires column to be recreated with encryption or new column added and data
migrated)
ALTER TABLE secure.identities
ALTER COLUMN ssn ADD
ENCRYPTED WITH (
ENCRYPTION_TYPE = 'RANDOMIZED',
ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256',
COLUMN_ENCRYPTION_KEY = MyCEK
) NULL;
-- Client-side: ensure application connection string enables Column Encryption
Setting=Enabled
-- (ADO.NET / JDBC drivers support this flag)
