function Export-EXOOverview { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO overview...' -Level INFO
  $ad = (Export-EXOAcceptedDomains -ReportPath $ReportPath).Data; $rd=(Export-EXORemoteDomains -ReportPath $ReportPath).Data; $cx=(Export-EXOConnectors -ReportPath $ReportPath).Data; $tr=(Export-EXOTransportRules -ReportPath $ReportPath).Data; $pp=(Export-EXOProtectionPolicies -ReportPath $ReportPath).Data
  $summary = [pscustomobject]@{ AcceptedDomains=$ad.Count; RemoteDomains=$rd.Count; Connectors=$cx.Count; TransportRules=$tr.Count; ContentFilterPolicies=($pp.HostedContentFilterPolicy | Measure-Object).Count; MalwarePolicies=($pp.MalwareFilterPolicy | Measure-Object).Count }
  $int = Write-IntermediateJson -Name 'exo-overview' -Data $summary -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-overview' -Data $summary -ReportPath $ReportPath -Title 'EXO Overview' -Intro 'Key EXO KPIs.'
  [pscustomobject]@{ Data=$summary; Intermediate=$int; Paths=$paths }
}
