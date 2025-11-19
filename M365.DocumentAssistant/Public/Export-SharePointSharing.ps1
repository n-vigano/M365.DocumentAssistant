function Export-SharePointSharing { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting SharePoint sharing posture...' -Level INFO
  $tenant=$null; $sites=@(); try { $tenant = Get-PnPTenant -ErrorAction Stop } catch { Write-Log -Level WARN -Message $_.Exception.Message }
  try { $sites = Get-PnPTenantSite -ErrorAction Stop | Select-Object Url,Title,Template,SharingCapability } catch { Write-Log -Level WARN -Message $_.Exception.Message }
  $bundle = [pscustomobject]@{ Tenant=$tenant; Sites=$sites }
  $int = Write-IntermediateJson -Name 'sharepoint-sharing' -Data $bundle -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'sharepoint-sharing' -Data $sites -ReportPath $ReportPath -Title 'SharePoint Sharing Posture' -Intro 'Tenant & site sharing configuration.'
  [pscustomobject]@{ Data=$bundle; Intermediate=$int; Paths=$paths }
}
