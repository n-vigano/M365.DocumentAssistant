function Export-Teams { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Teams...' -Level INFO
  $teams=@(); try { $teams = Get-Team } catch { Write-Log -Level WARN -Message $_.Exception.Message }
  $data = $teams | Select-Object GroupId,DisplayName,Visibility,Archived
  $int = Write-IntermediateJson -Name 'teams' -Data $data -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'teams' -Data $data -ReportPath $ReportPath -Title 'Teams' -Intro 'Microsoft Teams in tenant.'
  [pscustomobject]@{ Data=$data; Intermediate=$int; Paths=$paths }
}
