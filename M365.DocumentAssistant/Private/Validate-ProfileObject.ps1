function Validate-ProfileObject {
  [CmdletBinding()] param([Parameter(Mandatory)][psobject]$Profile)
  $errors = New-Object System.Collections.Generic.List[string]; $warnings = New-Object System.Collections.Generic.List[string]
  function _isGuid([string]$s){ return [Guid]::TryParse($s, [ref]([Guid]::Empty)) }
  foreach($fld in 'TenantId','TenantDomain','TenantAdminUrl','EXOUserPrincipalName'){
    if ($Profile.PSObject.Properties.Name -contains $fld){ $val = $Profile.$fld; if ($val -is [psobject]){ if (-not ($val.PSObject.Properties.Name -contains 'value' -and $val.PSObject.Properties.Name -contains 'alg')){ $errors.Add("$fld encrypted object missing value/alg") | Out-Null } } }
  }
  if ($Profile.TenantId -and -not (_isGuid([string]$Profile.TenantId) -or ([string]$Profile.TenantId -match '\.'))) { $warnings.Add('TenantId should be GUID or domain') | Out-Null }
  if ($Profile.TenantDomain -and ([string]$Profile.TenantDomain -notmatch '\.')) { $warnings.Add('TenantDomain should be a domain name') | Out-Null }
  if ($Profile.TenantAdminUrl -and ([string]$Profile.TenantAdminUrl -notmatch '^https?://.+-admin\\.sharepoint\\.com/?$')) { $warnings.Add('TenantAdminUrl should look like https://<tenant>-admin.sharepoint.com') | Out-Null }
  if ($Profile.EXOUserPrincipalName -and ([string]$Profile.EXOUserPrincipalName -notmatch '.+@.+')) { $warnings.Add('EXOUserPrincipalName should be a UPN') | Out-Null }
  @{ IsValid=($errors.Count -eq 0); Errors=$errors; Warnings=$warnings }
}
