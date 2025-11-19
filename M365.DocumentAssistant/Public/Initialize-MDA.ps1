function Initialize-MDA {
  [CmdletBinding()] param([string]$ReportPath='C:\\reports',[string]$LogPath='C:\\log',[switch]$EnableTranscript)
  $Script:MDA_ReportPath=$ReportPath; $Script:MDA_LogPath=$LogPath
  foreach($p in @($ReportPath,$LogPath)){ if (-not (Test-Path $p)){ New-Item -ItemType Directory -Path $p -Force | Out-Null } }
  $stamp=(Get-Date).ToString('yyyyMMdd_HHmmss'); $Script:MDA_LogFile = Join-Path $LogPath "m365-document-assistant_$stamp.log"
  if ($EnableTranscript){ try { Start-Transcript -Path (Join-Path $LogPath "transcript_$stamp.txt") -ErrorAction Stop | Out-Null } catch {} }
  Write-Log -Message "Initialized MDA. Reports: $ReportPath | Logs: $LogPath" -Level INFO
}
