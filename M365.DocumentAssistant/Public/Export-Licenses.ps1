function Export-Licenses { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting licenses...' -Level INFO
  $skus = Get-MgSubscribedSku
  $data = $skus | Select-Object skuId,skuPartNumber,appliesTo,consumedUnits,@{n='Enabled';e={$_.prepaidUnits.enabled}},@{n='Warning';e={$_.prepaidUnits.warning}},@{n='Suspended';e={$_.prepaidUnits.suspended}}
  $int = Write-IntermediateJson -Name 'licenses' -Data $data -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'licenses' -Data $data -ReportPath $ReportPath -Title 'Licenses' -Intro 'Subscribed SKUs & consumption.'
  [pscustomobject]@{ Data=$data; Intermediate=$int; Paths=$paths }
}
