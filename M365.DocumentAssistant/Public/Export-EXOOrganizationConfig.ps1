function Export-EXOOrganizationConfig { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO organization config...' -Level INFO
  try { $cfg = Get-OrganizationConfig | Select-Object DefaultDomain,PublicFoldersEnabled,OAuth2ClientProfileEnabled,MailTipsExternalRecipientsTipsEnabled } catch { $cfg=$null; Write-Log -Level ERROR -Message $_.Exception.Message }
  $data = if ($cfg){ @($cfg) } else { @() }
  $int = Write-IntermediateJson -Name 'exo-organization-config' -Data $data -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-organization-config' -Data $data -ReportPath $ReportPath -Title 'EXO: Organization Config' -Intro 'High-level organization settings.'
  [pscustomobject]@{ Data=$data; Intermediate=$int; Paths=$paths }
}
