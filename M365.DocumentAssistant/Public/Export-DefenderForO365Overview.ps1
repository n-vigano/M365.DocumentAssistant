function Export-DefenderForO365Overview { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Defender for Office 365 overview...' -Level INFO
  $pol = (Export-DefenderForO365Policies -ReportPath $ReportPath).Data
  $summary = [pscustomobject]@{ SafeLinksPolicies=($pol.SafeLinksPolicy | Measure-Object).Count; SafeLinksRules=($pol.SafeLinksRule | Measure-Object).Count; SafeAttachmentPolicies=($pol.SafeAttachmentPolicy | Measure-Object).Count; SafeAttachmentRules=($pol.SafeAttachmentRule | Measure-Object).Count; AntiPhishPolicies=($pol.AntiPhishPolicy | Measure-Object).Count; AntiPhishRules=($pol.AntiPhishRule | Measure-Object).Count }
  $int = Write-IntermediateJson -Name 'defender-o365-overview' -Data $summary -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'defender-o365-overview' -Data $summary -ReportPath $ReportPath -Title 'Defender for Office 365 Overview' -Intro 'KPI counts.'
  [pscustomobject]@{ Data=$summary; Intermediate=$int; Paths=$paths }
}
