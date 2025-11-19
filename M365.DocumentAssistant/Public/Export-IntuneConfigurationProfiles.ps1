function Export-IntuneConfigurationProfiles { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Intune configuration profiles...' -Level INFO
  $cfgs=@(); try { $resp = Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations'; $cfgs=@($resp.value) } catch {}
  $rows=@(); foreach($c in $cfgs){ $assign=@(); try { $ar = Invoke-MgGraphRequest -Method GET -Uri ("https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations/{0}/assignments" -f $c.id); $assign=@($ar.value) } catch {}; $rows += [pscustomobject]@{ Id=$c.id; DisplayName=$c.displayName; Platform=$c.'@odata.type'; Version=$c.version; LastModified=$c.lastModifiedDateTime; AssignmentCount=$assign.Count } }
  $int = Write-IntermediateJson -Name 'intune-configuration-profiles' -Data $cfgs -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'intune-configuration-profiles' -Data $rows -ReportPath $ReportPath -Title 'Intune Configuration Profiles' -Intro 'Device configurations + assignments count.'
  [pscustomobject]@{ Data=$cfgs; Intermediate=$int; Paths=$paths }
}
