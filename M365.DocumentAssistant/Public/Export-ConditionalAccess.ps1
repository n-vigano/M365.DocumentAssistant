function Export-ConditionalAccess { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Conditional Access...' -Level INFO
  $policies = Get-MgIdentityConditionalAccessPolicy -All; $locations = Get-MgIdentityConditionalAccessNamedLocation -All
  $flat = foreach($p in $policies){ [pscustomobject]@{ Id=$p.Id; DisplayName=$p.DisplayName; State=$p.State; Users=($p.Conditions.Users.IncludeUsers -join ';'); ClientApps=($p.Conditions.ClientAppTypes -join ';'); GrantControls=($p.GrantControls.BuiltInControls -join ';') } }
  $bundle = [pscustomobject]@{ Policies=$policies; NamedLocations=$locations }
  $int = Write-IntermediateJson -Name 'conditional-access' -Data $bundle -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'conditional-access' -Data $flat -ReportPath $ReportPath -Title 'Conditional Access' -Intro 'Policies and named locations overview.'
  [pscustomobject]@{ Data=$bundle; Intermediate=$int; Paths=$paths }
}
