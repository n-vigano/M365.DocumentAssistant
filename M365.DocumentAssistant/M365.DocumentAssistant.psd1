@{
  RootModule        = 'M365.DocumentAssistant.psm1'
  ModuleVersion     = '1.8.0'
  GUID              = 'e8a9b3a2-6f11-4e6f-9c64-9a57d04c9f8b'
  Author            = 'Nicola Viganò'
  CompanyName       = 'M365 Document Assistant'
  Copyright         = '(c) 2025 Nicola Viganò. All rights reserved.'
  Description       = 'Comprehensive M365 reporting with Lutech branding, CSV/JSON/HTML, intermediate JSON, logging, email, and profile-driven connections.'
  PowerShellVersion = '5.1'
  RequiredModules   = @('Microsoft.Graph','PnP.PowerShell','MicrosoftTeams','ExchangeOnlineManagement')
  FunctionsToExport = @('*')
  CmdletsToExport   = @()
  AliasesToExport   = @()
}
