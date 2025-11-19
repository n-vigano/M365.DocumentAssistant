function Export-IntuneCompliancePolicies { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Intune compliance policies...' -Level INFO
  $rows=@(); $bundle=@(); try { $pols = (Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies').value } catch { $pols=@() }
  foreach($p in $pols){ $assign=@(); try { $ar = Invoke-MgGraphRequest -Method GET -Uri ("https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies/{0}/assignments" -f $p.id); $assign=@($ar.value) } catch {}; $bundle += [pscustomobject]@{ Policy=$p; Assignments=$assign }; foreach($a in $assign){ $rows += [pscustomobject]@{ PolicyName=$p.displayName; Platform=$p.'@odata.type'; AssignmentId=$a.id; TargetType=$a.target.'@odata.type'; FilterId=$a.target.deviceAndAppManagementAssignmentFilterId; FilterMode=$a.target.deviceAndAppManagementAssignmentFilterType } }; if ($assign.Count -eq 0){ $rows += [pscustomobject]@{ PolicyName=$p.displayName; Platform=$p.'@odata.type'; AssignmentId=$null; TargetType=$null; FilterId=$null; FilterMode=$null } } }
  $int = Write-IntermediateJson -Name 'intune-compliance-policies' -Data $bundle -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'intune-compliance-policies' -Data $rows -ReportPath $ReportPath -Title 'Intune Compliance Policies' -Intro 'Policies with assignments.'
  [pscustomobject]@{ Data=$bundle; Intermediate=$int; Paths=$paths }
}
