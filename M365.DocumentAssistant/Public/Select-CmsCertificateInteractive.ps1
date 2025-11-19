function Select-CmsCertificateInteractive { [CmdletBinding()] param([switch]$CurrentUser,[switch]$LocalMachine)
  Write-Host '=== Select a CMS Certificate (recipient) ===' -ForegroundColor Cyan
  $list = Get-CmsCandidateCertificates -CurrentUser:$CurrentUser -LocalMachine:$LocalMachine
  if (-not $list -or $list.Count -eq 0){ Write-Host 'No candidate certificates found.' -ForegroundColor Yellow; return $null }
  $i=0; foreach($c in $list){ $i++; Write-Host ("[{0}] Thumbprint={1} | Subject={2} | Store={3} | NotAfter={4:yyyy-MM-dd} | HasPrivateKey={5}" -f $i,$c.Thumbprint,$c.Subject,$c.Store,$c.NotAfter,$c.HasPrivateKey) }
  $sel = Read-Host 'Enter the number to select (or press Enter to cancel)'; if ([string]::IsNullOrWhiteSpace($sel)){ return $null }
  [int]$idx=0; [void][int]::TryParse($sel,[ref]$idx); if ($idx -le 0 -or $idx -gt $list.Count){ Write-Host 'Invalid selection.' -ForegroundColor Red; return $null }
  $chosen = $list[$idx-1]; Write-Host ('Selected thumbprint: ' + $chosen.Thumbprint) -ForegroundColor Green; return $chosen.Thumbprint
}
