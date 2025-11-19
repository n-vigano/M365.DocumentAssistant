function Export-IntuneOverview { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Intune overview...' -Level INFO
  $devices=@(); $comp=@(); $cfg=@(); $apps=@(); $filters=@()
  try { $devices = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?$top=1').value } catch {}
  try { $comp = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies').value } catch {}
  try { $cfg = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations').value } catch {}
  try { $apps = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/deviceAppManagement/managedAppPolicies').value } catch {}
  try { $filters = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/beta/deviceManagement/assignmentFilters').value } catch {}
  $summary = [pscustomobject]@{ ManagedDevices=($devices | Measure-Object).Count; CompliancePolicies=($comp | Measure-Object).Count; ConfigurationProfiles=($cfg | Measure-Object).Count; ManagedAppPolicies=($apps | Measure-Object).Count; AssignmentFilters=($filters | Measure-Object).Count }
  $int = Write-IntermediateJson -Name 'intune-overview' -Data $summary -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'intune-overview' -Data $summary -ReportPath $ReportPath -Title 'Intune Overview' -Intro 'Top-level KPIs.'
  [pscustomobject]@{ Data=$summary; Intermediate=$int; Paths=$paths }
}
