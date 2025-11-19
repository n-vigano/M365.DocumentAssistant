function Export-EntraApplications { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Entra ID applications...' -Level INFO
  $apps = Get-MgApplication -All -Property Id,DisplayName,AppId,SignInAudience,CreatedDateTime,PasswordCredentials,KeyCredentials
  $data = $apps | Select-Object Id,DisplayName,AppId,SignInAudience,CreatedDateTime,@{n='PasswordSecrets';e={$_.PasswordCredentials.Count}},@{n='CertificateSecrets';e={$_.KeyCredentials.Count}}
  $int = Write-IntermediateJson -Name 'entra-apps' -Data $apps -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'entra-apps' -Data $data -ReportPath $ReportPath -Title 'App Registrations' -Intro 'Applications registered in Entra ID.'
  [pscustomobject]@{ Data=$apps; Intermediate=$int; Paths=$paths }
}
