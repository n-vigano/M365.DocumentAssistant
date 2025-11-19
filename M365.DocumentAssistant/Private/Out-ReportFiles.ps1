function Out-ReportFiles {
  [CmdletBinding()] param([Parameter(Mandatory)][string]$BaseName,[Parameter(Mandatory)][object]$Data,[string]$ReportPath,[string]$Title,[string]$Intro)
  $paths = Get-ReportPaths -BaseName $BaseName -ReportPath $ReportPath
  $Data | ConvertTo-Json -Depth 8 | Set-Content -Path $paths.Json -Encoding UTF8
  try { if ($Data -is [System.Collections.IEnumerable] -and -not ($Data -is [string])) { $Data | Export-Csv -Path $paths.Csv -NoTypeInformation -Encoding UTF8 } else { '' | Out-File -FilePath $paths.Csv } } catch { Write-Log -Level WARN -Message "CSV export failed for $BaseName: $($_.Exception.Message)" }
  if (-not $Title) { $Title = $BaseName }
  $html = New-HtmlReport -Title $Title -Data $Data -Subtitle $Intro
  $html | Set-Content -Path $paths.Html -Encoding UTF8
  Write-Log -Level INFO -Message "Exported $BaseName to: $($paths.Json), $($paths.Csv), $($paths.Html)"
  return $paths
}
