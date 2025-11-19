function New-MDAProfile {
[CmdletBinding()] param([Parameter(Mandatory)][string]$Path,[string]$TenantId,[string]$TenantDomain,[string]$TenantAdminUrl,[string]$EXOUserPrincipalName,[string[]]$GraphScopes=@('User.Read.All','Group.Read.All','Directory.Read.All','Policy.Read.All','Application.Read.All','Sites.Read.All','Mail.Send','DeviceManagementApps.Read.All','DeviceManagementConfiguration.Read.All','DeviceManagementManagedDevices.Read.All','DeviceManagementRBAC.Read.All'),[switch]$ConnectPnP,[switch]$ConnectTeams,[switch]$ConnectEXO,[switch]$Force)
  $dir = Split-Path -Path $Path -Parent; if ($dir -and -not (Test-Path $dir)){ New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  if ((Test-Path $Path) -and -not $Force){ throw "File exists: $Path (use -Force)" }
  $obj = [pscustomobject]@{ TenantId=$TenantId; TenantDomain=$TenantDomain; TenantAdminUrl=$TenantAdminUrl; EXOUserPrincipalName=$EXOUserPrincipalName; GraphScopes=$GraphScopes; ConnectPnP=[bool]$ConnectPnP; ConnectTeams=[bool]$ConnectTeams; ConnectEXO=[bool]$ConnectEXO }
  $val = Validate-ProfileObject -Profile $obj; if (-not $val.IsValid){ Write-Log -Level ERROR -Message 'Profile validation failed.'; throw 'Profile validation failed' }
  $obj | ConvertTo-Json -Depth 6 | Set-Content -Path $Path -Encoding UTF8; Write-Log -Level INFO -Message ("Profile written: "+$Path); return $Path
}
