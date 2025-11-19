function Export-IntuneSettingsCatalogPolicies { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting Intune settings catalog policies...' -Level INFO
  $pols=@(); try { $resp = Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/beta/deviceManagement/configurationPolicies'; $pols=@($resp.value) } catch {}
  $rows=@(); foreach($p in $pols){ $assign=@(); try { $ar = Invoke-MgGraphRequest -Method GET -Uri ("https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/{0}/assignments" -f $p.id); $assign=@($ar.value) } catch {}; $settingsCount=$null; try { $sett = Invoke-MgGraphRequest -Method GET -Uri ("https://graph.microsoft.com/beta/deviceManagement/configurationPolicies/{0}/settings" -f $p.id); $settingsCount = (@($sett.value)).Count } catch {}; $rows += [pscustomobject]@{ Id=$p.id; DisplayName=$p.name; Description=$p.description; Platform=$p.platforms; Technologies=$p.technologies; SettingsCount=$settingsCount; AssignmentCount=$assign.Count } }
  $int = Write-IntermediateJson -Name 'intune-settings-catalog' -Data $pols -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'intune-settings-catalog' -Data $rows -ReportPath $ReportPath -Title 'Intune Settings Catalog' -Intro 'Settings catalog (beta).'
  [pscustomobject]@{ Data=$pols; Intermediate=$int; Paths=$paths }
}
