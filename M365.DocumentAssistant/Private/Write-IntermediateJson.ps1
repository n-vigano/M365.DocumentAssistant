function Write-IntermediateJson {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$Name,[Parameter(Mandatory)][object]$Data,[string]$ReportPath)
  if (-not $ReportPath) { $ReportPath = $Script:MDA_ReportPath }
  if (-not $ReportPath) { $ReportPath = 'C:\\reports' }
  $intermediate = Join-Path $ReportPath 'intermediate'
  if (-not (Test-Path $intermediate)) { New-Item -ItemType Directory -Path $intermediate -Force | Out-Null }
  $path = Join-Path $intermediate ("{0}.json" -f $Name)
  $Data | ConvertTo-Json -Depth 8 | Set-Content -Path $path -Encoding UTF8
  Write-Log -Message "Intermediate JSON saved: $path" -Level INFO
  return $path
}
