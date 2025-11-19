function Export-EXOProtectionPolicies { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO protection policies...' -Level INFO
  $bundle=[pscustomobject]@{}
  try { $hcp = Get-HostedContentFilterPolicy } catch { $hcp=@() }
  try { $hcr = Get-HostedContentFilterRule } catch { $hcr=@() }
  try { $hcf = Get-HostedConnectionFilterPolicy } catch { $hcf=@() }
  try { $mfp = Get-MalwareFilterPolicy } catch { $mfp=@() }
  try { $mfr = Get-MalwareFilterRule } catch { $mfr=@() }
  $bundle = [pscustomobject]@{ HostedContentFilterPolicy=$hcp; HostedContentFilterRule=$hcr; HostedConnectionFilterPolicy=$hcf; MalwareFilterPolicy=$mfp; MalwareFilterRule=$mfr }
  $summary=@(); foreach($p in $hcp){ $summary += [pscustomobject]@{ Type='HostedContentFilterPolicy'; Name=$p.Name; SpamAction=$p.SpamAction; BulkSpamAction=$p.BulkSpamAction } }; foreach($p in $hcf){ $summary += [pscustomobject]@{ Type='HostedConnectionFilterPolicy'; Name=$p.Name; IPAllowList=([string]::Join(';',$p.IPAllowList)); IPBlockList=([string]::Join(';',$p.IPBlockList)) } }; foreach($p in $mfp){ $summary += [pscustomobject]@{ Type='MalwareFilterPolicy'; Name=$p.Name; EnableFileFilter=$p.EnableFileFilter } }
  $int = Write-IntermediateJson -Name 'exo-protection-policies' -Data $bundle -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-protection-policies' -Data $summary -ReportPath $ReportPath -Title 'EXO: EOP Policies' -Intro 'Anti-spam & anti-malware policies.'
  [pscustomobject]@{ Data=$bundle; Intermediate=$int; Paths=$paths }
}
