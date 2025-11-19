function New-MDAProfileInteractive {
[CmdletBinding()] param([Parameter(Mandatory)][string]$Path)
  Write-Host '=== MDA Profile Interactive Creator ===' -ForegroundColor Cyan
  $TenantId = Read-Host 'TenantId (GUID or domain); leave blank to skip'
  $TenantDomain = Read-Host 'Tenant primary domain (e.g. contoso.onmicrosoft.com)'
  $TenantAdminUrl = Read-Host 'SharePoint Admin URL (e.g. https://contoso-admin.sharepoint.com)'
  $EXOUPN = Read-Host 'EXO User Principal Name (user@domain)'
  $GraphScopes = @('User.Read.All','Group.Read.All','Directory.Read.All','Policy.Read.All','Application.Read.All','Sites.Read.All','Mail.Send','DeviceManagementApps.Read.All','DeviceManagementConfiguration.Read.All','DeviceManagementManagedDevices.Read.All','DeviceManagementRBAC.Read.All')
  $ConnectPnP = (Read-Host 'Connect to SharePoint Admin (PnP)? (Y/N)') -match '^(y|yes)$'
  $ConnectTeams = (Read-Host 'Connect to Microsoft Teams? (Y/N)') -match '^(y|yes)$'
  $ConnectEXO = (Read-Host 'Connect to Exchange Online? (Y/N)') -match '^(y|yes)$'
  $encryptAns = Read-Host 'Encrypt any fields? (Y/N)'; $encryptList=@(); $encAlg='DPAPIUser'; $thumb=$null
  if ($encryptAns -match '^(y|yes)$'){ $fields = Read-Host 'Which fields to encrypt? (TenantId,TenantDomain,TenantAdminUrl,EXOUserPrincipalName comma-separated)'; $encryptList = $fields.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }; $encAlg = Read-Host 'Encryption algorithm: DPAPIUser or CMS (default DPAPIUser)'; if ([string]::IsNullOrWhiteSpace($encAlg)) { $encAlg='DPAPIUser' }; if ($encAlg -eq 'CMS'){ $thumb = Read-Host 'Certificate thumbprint for CMS (leave blank to select interactively)'; if ([string]::IsNullOrWhiteSpace($thumb)){ $thumb = Select-CmsCertificateInteractive -CurrentUser -LocalMachine } } }
  $obj = [pscustomobject]@{ TenantId=$TenantId; TenantDomain=$TenantDomain; TenantAdminUrl=$TenantAdminUrl; EXOUserPrincipalName=$EXOUPN; GraphScopes=$GraphScopes; ConnectPnP=[bool]$ConnectPnP; ConnectTeams=[bool]$ConnectTeams; ConnectEXO=[bool]$ConnectEXO }
  foreach($f in $encryptList){ if ([string]::IsNullOrWhiteSpace($obj.$f)) { continue } ; try { $enc = Protect-String -PlainText ([string]$obj.$f) -Algorithm $encAlg -CertificateThumbprint $thumb; $obj | Add-Member -Force -NotePropertyName $f -NotePropertyValue $enc } catch { Write-Log -Level WARN -Message ("Encryption failed for field " + $f + ": " + $_.Exception.Message) } }
  $res = Validate-ProfileObject -Profile $obj; if (-not $res.IsValid){ Write-Log -Level ERROR -Message 'Profile did not pass validation'; foreach($e in $res.Errors){ Write-Host ('ERROR: ' + $e) -ForegroundColor Red }; return }
  $dir = Split-Path -Path $Path -Parent; if ($dir -and -not (Test-Path $dir)){ New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  $obj | ConvertTo-Json -Depth 6 | Set-Content -Path $Path -Encoding UTF8; Write-Host ('Profile saved to ' + $Path) -ForegroundColor Green
}
