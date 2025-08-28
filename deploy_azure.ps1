# scripts/deploy_azure.ps1
param(
[string] $SqlServerName,
[string] $DatabaseName,
[string] $AdminUser
)
if (-not $SqlServerName -or -not $DatabaseName) {
Write-Error "Usage: .\deploy_azure.ps1 -SqlServerName <server> -DatabaseName
<db> -AdminUser <admin>"
exit 1
}
Write-Output "Deploying Azure SQL artifacts to $SqlServerName/$DatabaseName"
# This script assumes Az CLI is logged in and user has sufficient permissions.
# Export the SQL files to temporary combined script and run via sqlcmd (or
invoke-sqlcmd if available)
$combined = "$(Get-Content azure\01_schema_core.sql),$(Get-Content
azure\02_schema_secure.sql),$(Get-Content azure\03_roles_and_rbac.sql),$(GetContent azure\04_always_encrypted_setup.sql),$(Get-Content
azure\05_auditing_and_alerts.sql)" -join "`nGO`n"
$temp = [IO.Path]::GetTempFileName()
Set-Content -Path $temp -Value $combined -Encoding UTF8
# requires sqlcmd
$sqlcmd =
"sqlcmd -S tcp:$SqlServerName.database.windows.net -d $DatabaseName -U
$AdminUser -P '<PASSWORD>' -i $temp"
Write-Output "Run the following command (replace password): $sqlcmd"
# cleanup
# Remove-Item $temp
