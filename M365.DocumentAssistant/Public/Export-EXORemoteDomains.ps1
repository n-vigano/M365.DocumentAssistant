function Export-EXORemoteDomains { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO remote domains...' -Level INFO
  try { $remotes = Get-RemoteDomain | Select-Object DomainName,Name,AllowedOOFType,AutoForwardEnabled,AutoReplyEnabled,DeliveryReportEnabled,TNEFEnabled } catch { $remotes=@(); Write-Log -Level ERROR -Message $_.Exception.Message }
  $int = Write-IntermediateJson -Name 'exo-remote-domains' -Data $remotes -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-remote-domains' -Data $remotes -ReportPath $ReportPath -Title 'EXO: Remote Domains' -Intro 'Partner/remote domain policies.'
  [pscustomobject]@{ Data=$remotes; Intermediate=$int; Paths=$paths }
}
