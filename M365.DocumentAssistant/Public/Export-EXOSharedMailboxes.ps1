function Export-EXOSharedMailboxes { [CmdletBinding()] param([string]$ReportPath)
  Write-Log -Message 'Exporting EXO shared mailboxes...' -Level INFO
  try { $mbxs = Get-EXOMailbox -ResultSize Unlimited -RecipientTypeDetails SharedMailbox -Properties DisplayName,PrimarySmtpAddress,Alias,WhenCreated,AuditEnabled,ArchiveStatus,HiddenFromAddressListsEnabled } catch { $mbxs=@(); Write-Log -Level ERROR -Message $_.Exception.Message }
  $rows = $mbxs | Select-Object DisplayName,PrimarySmtpAddress,Alias,WhenCreated,AuditEnabled,ArchiveStatus,HiddenFromAddressListsEnabled
  $int = Write-IntermediateJson -Name 'exo-shared-mailboxes' -Data $rows -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-shared-mailboxes' -Data $rows -ReportPath $ReportPath -Title 'EXO: Shared Mailboxes' -Intro 'Shared mailbox inventory.'
  [pscustomobject]@{ Data=$rows; Intermediate=$int; Paths=$paths }
}
