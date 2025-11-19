function Write-Log {
  [CmdletBinding()]
  param(
    [ValidateSet('INFO','WARN','ERROR','DEBUG')][string]$Level='INFO',
    [Parameter(Mandatory)][string]$Message
  )
  if (-not $Script:MDA_LogPath) { $Script:MDA_LogPath = 'C:\\log' }
  if (-not (Test-Path $Script:MDA_LogPath)) { New-Item -ItemType Directory -Path $Script:MDA_LogPath -Force | Out-Null }
  if (-not $Script:MDA_LogFile) { $stamp = (Get-Date).ToString('yyyyMMdd_HHmmss'); $Script:MDA_LogFile = Join-Path $Script:MDA_LogPath "m365-document-assistant_$stamp.log" }
  $line = "$(Get-Date -Format o) [$Level] $Message"
  Add-Content -Path $Script:MDA_LogFile -Value $line
  switch($Level){ 'ERROR'{Write-Error $Message}; 'WARN'{Write-Warning $Message}; 'DEBUG'{Write-Verbose $Message}; default{Write-Host $Message} }
}
