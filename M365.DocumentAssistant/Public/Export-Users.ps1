function Export-Users { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting users...' -Level INFO
  $users = Get-MgUser -All -Property id,displayName,mail,userPrincipalName,accountEnabled,createdDateTime,userType,jobTitle,department,companyName,signInActivity,assignedLicenses
  $data = $users | Select-Object id,displayName,mail,userPrincipalName,accountEnabled,userType,jobTitle,department,companyName,@{n='Created';e={$_.createdDateTime}},@{n='LastSignIn';e={$_.signInActivity.lastSignInDateTime}},@{n='AssignedSkuIds';e={[string]::Join(';', ($_.assignedLicenses.skuId))}}
  $int = Write-IntermediateJson -Name 'users' -Data $data -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'users' -Data $data -ReportPath $ReportPath -Title 'M365 Users' -Intro 'All Entra ID users.'
  [pscustomobject]@{ Data=$data; Intermediate=$int; Paths=$paths }
}
