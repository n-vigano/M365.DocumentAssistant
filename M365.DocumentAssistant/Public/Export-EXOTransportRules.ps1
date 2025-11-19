function Export-EXOTransportRules { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO transport rules...' -Level INFO
  try { $rules = Get-TransportRule } catch { $rules=@(); Write-Log -Level ERROR -Message $_.Exception.Message }
  $flat = foreach($r in $rules){ [pscustomobject]@{ Name=$r.Name; Priority=$r.Priority; Enabled=$r.Enabled; Mode=$r.Mode; Conditions=[string]($r.Conditions | ConvertTo-Json -Depth 4); Actions=[string]($r.Actions | ConvertTo-Json -Depth 4); Exceptions=[string]($r.Exceptions | ConvertTo-Json -Depth 4) } }
  $int = Write-IntermediateJson -Name 'exo-transport-rules' -Data $flat -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-transport-rules' -Data $flat -ReportPath $ReportPath -Title 'EXO: Transport Rules' -Intro 'Mail flow rules.'
  [pscustomobject]@{ Data=$flat; Intermediate=$int; Paths=$paths }
}
