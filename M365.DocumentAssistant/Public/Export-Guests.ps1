function Export-Guests { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting guest users...' -Level INFO
  $guests = Get-MgUser -All -Filter "userType eq 'Guest'" -Property id,displayName,mail,userPrincipalName,createdDateTime,externalUserState
  $data = $guests | Select-Object id,displayName,mail,userPrincipalName,externalUserState,@{n='Created';e={$_.createdDateTime}}
  $int = Write-IntermediateJson -Name 'guests' -Data $data -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'guests' -Data $data -ReportPath $ReportPath -Title 'Guest Users' -Intro 'External users invited.'
  [pscustomobject]@{ Data=$data; Intermediate=$int; Paths=$paths }
}
