function Get-CmsCandidateCertificates {
  [CmdletBinding()] param([switch]$CurrentUser,[switch]$LocalMachine)
  if (-not $CurrentUser -and -not $LocalMachine) { $CurrentUser=$true; $LocalMachine=$true }
  $stores=@(); if ($CurrentUser){$stores+='Cert:\\CurrentUser\\My'}; if ($LocalMachine){$stores+='Cert:\\LocalMachine\\My'}
  $res=@(); foreach($s in $stores){ try { $res += Get-ChildItem -Path $s -ErrorAction Stop } catch {} }
  foreach($c in $res){ if ($c.NotAfter -lt (Get-Date)) { continue }; [pscustomobject]@{ Store = ($c.PSParentPath -like '*CurrentUser*') ? 'CurrentUser\\My' : 'LocalMachine\\My'; Subject=$c.Subject; Thumbprint=$c.Thumbprint; NotAfter=$c.NotAfter; HasPrivateKey=$c.HasPrivateKey; EnhancedKeyUsage = ($c.EnhancedKeyUsageList | ForEach-Object { $_.FriendlyName }) -join '; ' } }
}
