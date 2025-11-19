function Export-DefenderForO365Policies { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Defender for Office 365 policies...' -Level INFO
  try { $slp = Get-SafeLinksPolicy } catch { $slp=@(); Write-Log -Level WARN -Message $_.Exception.Message }
  try { $slr = Get-SafeLinksRule } catch { $slr=@() }
  try { $sap = Get-SafeAttachmentPolicy } catch { $sap=@() }
  try { $sar = Get-SafeAttachmentRule } catch { $sar=@() }
  try { $app = Get-AntiPhishPolicy } catch { $app=@() }
  try { $apr = Get-AntiPhishRule } catch { $apr=@() }
  $bundle = [pscustomobject]@{ SafeLinksPolicy=$slp; SafeLinksRule=$slr; SafeAttachmentPolicy=$sap; SafeAttachmentRule=$sar; AntiPhishPolicy=$app; AntiPhishRule=$apr }
  $rows=@(); foreach($p in $slp){ $rows += [pscustomobject]@{ Type='SafeLinksPolicy'; Name=$p.Name; Enable=$p.EnableSafeLinksForClients; ScanUrls=$p.ScanUrls } }; foreach($p in $sap){ $rows += [pscustomobject]@{ Type='SafeAttachmentPolicy'; Name=$p.Name; Enable=$p.Enable; Action=$p.Action; Redirect=$p.Redirect } }; foreach($p in $app){ $rows += [pscustomobject]@{ Type='AntiPhishPolicy'; Name=$p.Name; PhishThresholdLevel=$p.PhishThresholdLevel } }
  $int = Write-IntermediateJson -Name 'defender-o365-policies' -Data $bundle -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'defender-o365-policies' -Data $rows -ReportPath $ReportPath -Title 'Defender for Office 365 Policies' -Intro 'Safe Links / Safe Attachments / Anti-Phish.'
  [pscustomobject]@{ Data=$bundle; Intermediate=$int; Paths=$paths }
}
