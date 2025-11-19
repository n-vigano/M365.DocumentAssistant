function Export-ExpiringSecrets { [CmdletBinding()] param([string]$ReportPath,[int]$DaysThreshold=60)
  Write-Log -Message "Exporting secrets expiring within $DaysThreshold days..." -Level INFO
  $apps = Get-MgApplication -All -Property Id,DisplayName,PasswordCredentials,KeyCredentials
  $spns = Get-MgServicePrincipal -All -Property Id,DisplayName,PasswordCredentials,KeyCredentials
  $deadline = (Get-Date).AddDays($DaysThreshold)
  $records=@()
  foreach($a in $apps){ foreach($p in $a.PasswordCredentials){ if ($p.EndDateTime -and $p.EndDateTime -le $deadline){ $records += [pscustomobject]@{ Type='AppRegistration'; ContainerId=$a.Id; Container=$a.DisplayName; CredType='Password'; EndDate=$p.EndDateTime } } }; foreach($k in $a.KeyCredentials){ if ($k.EndDateTime -and $k.EndDateTime -le $deadline){ $records += [pscustomobject]@{ Type='AppRegistration'; ContainerId=$a.Id; Container=$a.DisplayName; CredType='Certificate'; EndDate=$k.EndDateTime } } }
  foreach($s in $spns){ foreach($p in $s.PasswordCredentials){ if ($p.EndDateTime -and $p.EndDateTime -le $deadline){ $records += [pscustomobject]@{ Type='ServicePrincipal'; ContainerId=$s.Id; Container=$s.DisplayName; CredType='Password'; EndDate=$p.EndDateTime } } }; foreach($k in $s.KeyCredentials){ if ($k.EndDateTime -and $k.EndDateTime -le $deadline){ $records += [pscustomobject]@{ Type='ServicePrincipal'; ContainerId=$s.Id; Container=$s.DisplayName; CredType='Certificate'; EndDate=$k.EndDateTime } } }
  $int = Write-IntermediateJson -Name 'expiring-secrets' -Data $records -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'expiring-secrets' -Data $records -ReportPath $ReportPath -Title 'Expiring Secrets' -Intro "Credentials expiring by $($deadline.ToString('yyyy-MM-dd'))."
  [pscustomobject]@{ Data=$records; Intermediate=$int; Paths=$paths }
}
