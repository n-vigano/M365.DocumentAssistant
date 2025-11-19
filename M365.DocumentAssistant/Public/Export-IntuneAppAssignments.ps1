function Export-IntuneAppAssignments { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Intune app assignments...' -Level INFO
  $apps=@(); $rows=@(); try { $resp = Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/beta/deviceAppManagement/mobileApps?$expand=assignments'; $apps=@($resp.value) } catch {}
  foreach($a in $apps){ $assign=@($a.assignments); if (-not $assign -or $assign.Count -eq 0){ $rows += [pscustomobject]@{ AppName=$a.displayName; AppId=$a.id; Platform=$a.'@odata.type'; AssignmentId=$null; Intent=$null; TargetType=$null; GroupId=$null; FilterId=$null; FilterMode=$null }; continue }; foreach($as in $assign){ $t=$as.target; $rows += [pscustomobject]@{ AppName=$a.displayName; AppId=$a.id; Platform=$a.'@odata.type'; AssignmentId=$as.id; Intent=$as.intent; TargetType=$t.'@odata.type'; GroupId=$t.groupId; FilterId=$t.deviceAndAppManagementAssignmentFilterId; FilterMode=$t.deviceAndAppManagementAssignmentFilterType } } }
  $int = Write-IntermediateJson -Name 'intune-app-assignments' -Data $apps -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'intune-app-assignments' -Data $rows -ReportPath $ReportPath -Title 'Intune App Assignments' -Intro 'Targets, intent, filters.'
  [pscustomobject]@{ Data=$apps; Intermediate=$int; Paths=$paths }
}
