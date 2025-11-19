function Export-EXOAcceptedDomains { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO accepted domains...' -Level INFO
  try { $domains = Get-AcceptedDomain | Select-Object Name,DomainType,Default,InitialDomain,IsCoexistenceDomain,MatchSubDomains } catch { $domains=@(); Write-Log -Level ERROR -Message $_.Exception.Message }
  $int = Write-IntermediateJson -Name 'exo-accepted-domains' -Data $domains -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-accepted-domains' -Data $domains -ReportPath $ReportPath -Title 'EXO: Accepted Domains' -Intro 'Mail flow domains.'
  [pscustomobject]@{ Data=$domains; Intermediate=$int; Paths=$paths }
}
