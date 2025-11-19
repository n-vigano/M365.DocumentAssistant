function Get-ReportPaths {
  [CmdletBinding()] param([Parameter(Mandatory)][string]$BaseName,[string]$ReportPath)
  if (-not $ReportPath) { $ReportPath = $Script:MDA_ReportPath }
  if (-not $ReportPath) { $ReportPath = 'C:\\reports' }
  if (-not (Test-Path $ReportPath)) { New-Item -ItemType Directory -Path $ReportPath -Force | Out-Null }
  @{ Csv=(Join-Path $ReportPath "$BaseName.csv"); Json=(Join-Path $ReportPath "$BaseName.json"); Html=(Join-Path $ReportPath "$BaseName.html") }
}
