# M365.DocumentAssistant.psm1
$moduleRoot = Split-Path -Parent $PSCommandPath
Get-ChildItem -Path (Join-Path $moduleRoot 'Private') -Filter '*.ps1' -File | ForEach-Object { . $_.FullName }
Get-ChildItem -Path (Join-Path $moduleRoot 'Public')  -Filter '*.ps1' -File | ForEach-Object { . $_.FullName }
Export-ModuleMember -Function *
