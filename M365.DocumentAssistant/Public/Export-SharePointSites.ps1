function Export-SharePointSites { [CmdletBinding()] param([string]$ReportPath,[string]$TenantAdminUrl)
  Write-Log -Message 'Exporting SharePoint sites...' -Level INFO
  $sites=@(); if (Get-Module -ListAvailable -Name PnP.PowerShell){ try { if ($TenantAdminUrl){ Connect-PnPOnline -Url $TenantAdminUrl -Interactive }; $sites = Get-PnPTenantSite -IncludeOneDriveSites } catch { Write-Log -Level WARN -Message $_.Exception.Message } }
  if (-not $sites -or $sites.Count -eq 0){ Write-Log -Level WARN -Message 'Falling back to Graph Sites'; $sites = Get-MgSite -Search '*' -All }
  $data = $sites | Select-Object Url,Title,Template,StorageUsageCurrent,Owner,LastContentModifiedDate
  $int = Write-IntermediateJson -Name 'sharepoint-sites' -Data $data -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'sharepoint-sites' -Data $data -ReportPath $ReportPath -Title 'SharePoint Sites' -Intro 'Tenant sites overview.'
  [pscustomobject]@{ Data=$data; Intermediate=$int; Paths=$paths }
}
