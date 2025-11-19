function Export-EXOMailboxPermissions { [CmdletBinding()] param([string]$ReportPath,[switch]$SharedOnly)
  Write-Log -Message 'Exporting EXO mailbox permissions...' -Level INFO
  try { $targets = if ($SharedOnly) { Get-EXOMailbox -ResultSize Unlimited -RecipientTypeDetails SharedMailbox | Select-Object -ExpandProperty PrimarySmtpAddress } else { Get-EXOMailbox -ResultSize Unlimited | Select-Object -ExpandProperty PrimarySmtpAddress } } catch { $targets=@(); Write-Log -Level ERROR -Message $_.Exception.Message }
  $rows=@(); foreach($id in $targets){ try { $perms = Get-MailboxPermission -Identity $id | Where-Object { -not $_.IsInherited }; foreach($p in $perms){ $rows += [pscustomobject]@{ Mailbox=$id; User=$p.User; AccessRights=([string]::Join(';',$p.AccessRights)); Deny=$p.Deny; Inherited=$p.IsInherited } } } catch { Write-Log -Level WARN -Message $_.Exception.Message } }
  $int = Write-IntermediateJson -Name 'exo-mailbox-permissions' -Data $rows -ReportPath $ReportPath
  $paths = Out-ReportFiles -BaseName 'exo-mailbox-permissions' -Data $rows -ReportPath $ReportPath -Title 'EXO: Mailbox Permissions' -Intro 'Explicit (non-inherited) permissions.'
  [pscustomobject]@{ Data=$rows; Intermediate=$int; Paths=$paths }
}
