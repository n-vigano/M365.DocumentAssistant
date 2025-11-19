function Export-EXOConnectors { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO connectors...' -Level INFO
  $rows=@(); try { $inb = Get-InboundConnector } catch { $inb=@(); Write-Log -Level WARN -Message $_.Exception.Message }; try { $outb = Get-OutboundConnector } catch { $outb=@(); Write-Log -Level WARN -Message $_.Exception.Message }
  foreach($c in $inb){ $rows += [pscustomobject]@{ Direction='Inbound'; Name=$c.Name; Enabled=$c.Enabled; ConnectorType=$c.ConnectorType; RequireTls=$c.RequireTls; SenderDomains=($c.SenderDomains -join ';') } }
  foreach($c in $outb){ $rows += [pscustomobject]@{ Direction='Outbound'; Name=$c.Name; Enabled=$c.Enabled; ConnectorType=$c.ConnectorType; SmartHosts=($c.SmartHosts -join ';'); TlsSettings=$c.TlsSettings } }
  $int = Write-IntermediateJson -Name 'exo-connectors' -Data $rows -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-connectors' -Data $rows -ReportPath $ReportPath -Title 'EXO: Connectors' -Intro 'Inbound & outbound connectors.'
  [pscustomobject]@{ Data=$rows; Intermediate=$int; Paths=$paths }
}
