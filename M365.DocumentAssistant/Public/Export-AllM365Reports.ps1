function Export-AllM365Reports {
[CmdletBinding()] param([string]$ReportPath,[string]$TenantAdminUrl,[switch]$IncludeMailboxStatistics)
  Initialize-MDA -ReportPath ($ReportPath ? $ReportPath : 'C:\\reports')
  Export-TenantConfig -ReportPath $ReportPath | Out-Null
  Export-Users -ReportPath $ReportPath | Out-Null
  Export-Guests -ReportPath $ReportPath | Out-Null
  Export-Groups -ReportPath $ReportPath | Out-Null
  Export-Licenses -ReportPath $ReportPath | Out-Null
  Export-SharePointSites -ReportPath $ReportPath -TenantAdminUrl $TenantAdminUrl | Out-Null
  Export-SharePointSharing -ReportPath $ReportPath | Out-Null
  Export-Teams -ReportPath $ReportPath | Out-Null
  Export-EntraApplications -ReportPath $ReportPath | Out-Null
  Export-EnterpriseApps -ReportPath $ReportPath | Out-Null
  Export-ExpiringSecrets -ReportPath $ReportPath | Out-Null
  Export-ConditionalAccess -ReportPath $ReportPath | Out-Null
  Export-ConditionalAccessDeepDive -ReportPath $ReportPath | Out-Null
  Export-DefenderForO365Policies -ReportPath $ReportPath | Out-Null
  Export-DefenderForO365Overview -ReportPath $ReportPath | Out-Null
  Export-EXOAcceptedDomains -ReportPath $ReportPath | Out-Null
  Export-EXORemoteDomains -ReportPath $ReportPath | Out-Null
  Export-EXOConnectors -ReportPath $ReportPath | Out-Null
  Export-EXOTransportRules -ReportPath $ReportPath | Out-Null
  Export-EXOOrganizationConfig -ReportPath $ReportPath | Out-Null
  Export-EXOProtectionPolicies -ReportPath $ReportPath | Out-Null
  Export-EXOMailboxes -ReportPath $ReportPath -IncludeStatistics:$IncludeMailboxStatistics | Out-Null
  Export-EXOSharedMailboxes -ReportPath $ReportPath | Out-Null
  Export-EXOMailboxPermissions -ReportPath $ReportPath -SharedOnly | Out-Null
  Export-EXOOverview -ReportPath $ReportPath | Out-Null
  Export-IntuneOverview -ReportPath $ReportPath | Out-Null
  Export-IntuneCompliancePolicies -ReportPath $ReportPath | Out-Null
  Export-IntuneAssignmentFilters -ReportPath $ReportPath | Out-Null
  Export-IntuneConfigurationProfiles -ReportPath $ReportPath | Out-Null
  Export-IntuneSettingsCatalogPolicies -ReportPath $ReportPath | Out-Null
  Export-IntuneAppAssignments -ReportPath $ReportPath | Out-Null
  Export-IntuneAppProtectionPolicies -ReportPath $ReportPath | Out-Null
}
