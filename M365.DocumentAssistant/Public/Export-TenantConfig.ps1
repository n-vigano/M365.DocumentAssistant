function Export-TenantConfig { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting tenant configuration...' -Level INFO
  try { $org = Get-MgOrganization -Property Id,DisplayName,VerifiedDomains,OnPremisesSyncEnabled; $domains = Get-MgDomain -All } catch { Write-Log -Level ERROR -Message $_.Exception.Message; $org=$null; $domains=@() }
  $tenant = [pscustomobject]@{ OrganizationId=$org.Id; OrganizationName=$org.DisplayName; VerifiedDomains=($org.VerifiedDomains.Name -join ','); OnPremisesSyncEnabled=$org.OnPremisesSyncEnabled; DomainCount=$domains.Count }
  $int = Write-IntermediateJson -Name 'tenant-config' -Data $tenant -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'tenant-config' -Data @($tenant) -ReportPath $ReportPath -Title 'Tenant Configuration' -Intro 'High-level tenant settings.'
  [pscustomobject]@{ Data=$tenant; Intermediate=$int; Paths=$paths }
}
