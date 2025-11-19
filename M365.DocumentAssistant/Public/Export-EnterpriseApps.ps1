function Export-EnterpriseApps { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Enterprise Applications...' -Level INFO
  $spns = Get-MgServicePrincipal -All -Property Id,DisplayName,AppId,PublisherName,ServicePrincipalType,PasswordCredentials,KeyCredentials
  $data = $spns | Select-Object Id,DisplayName,AppId,PublisherName,ServicePrincipalType,@{n='PasswordSecrets';e={$_.PasswordCredentials.Count}},@{n='CertificateSecrets';e={$_.KeyCredentials.Count}}
  $int = Write-IntermediateJson -Name 'enterprise-apps' -Data $spns -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'enterprise-apps' -Data $data -ReportPath $ReportPath -Title 'Enterprise Apps' -Intro 'Service principals overview.'
  [pscustomobject]@{ Data=$spns; Intermediate=$int; Paths=$paths }
}
