function Import-IntermediateJson {
  [CmdletBinding()] param([Parameter(Mandatory)][string]$Name,[string]$ReportPath)
  if (-not $ReportPath) { $ReportPath = $Script:MDA_ReportPath }
  if (-not $ReportPath) { $ReportPath = 'C:\\reports' }
  $path = Join-Path (Join-Path $ReportPath 'intermediate') ("{0}.json" -f $Name)
  if (-not (Test-Path $path)) { throw "Intermediate not found: $path" }
  Write-Log -Message ("Importing intermediate: "+$path) -Level INFO
  Get-Content -Path $path -Raw | ConvertFrom-Json
}
