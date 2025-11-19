function Export-Groups { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting groups...' -Level INFO
  $groups = Get-MgGroup -All -Property id,displayName,mail,groupTypes,mailEnabled,securityEnabled,createdDateTime,resourceProvisioningOptions
  $data = $groups | Select-Object id,displayName,mail,mailEnabled,securityEnabled,@{n='IsMicrosoft365';e={($_.groupTypes -contains 'Unified')}},@{n='IsTeam';e={($_.resourceProvisioningOptions -contains 'Team')}},@{n='Created';e={$_.createdDateTime}}
  $int = Write-IntermediateJson -Name 'groups' -Data $data -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'groups' -Data $data -ReportPath $ReportPath -Title 'Groups' -Intro 'Security, mail-enabled, Microsoft 365 groups.'
  [pscustomobject]@{ Data=$data; Intermediate=$int; Paths=$paths }
}
