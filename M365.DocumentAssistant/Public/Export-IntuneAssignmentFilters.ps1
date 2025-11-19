function Export-IntuneAssignmentFilters { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Intune assignment filters...' -Level INFO
  $filters=@(); try { $resp = Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/beta/deviceManagement/assignmentFilters'; $filters=@($resp.value) } catch {}
  $rows = foreach($f in $filters){ [pscustomobject]@{ Id=$f.id; DisplayName=$f.displayName; Platform=$f.platform; RoleScopeTags=([string]::Join(';',$f.roleScopeTags)); Rule=$f.rule; State=$f.state } }
  $int = Write-IntermediateJson -Name 'intune-assignment-filters' -Data $filters -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'intune-assignment-filters' -Data $rows -ReportPath $ReportPath -Title 'Intune Assignment Filters' -Intro 'Criteria-based targeting filters.'
  [pscustomobject]@{ Data=$filters; Intermediate=$int; Paths=$paths }
}
