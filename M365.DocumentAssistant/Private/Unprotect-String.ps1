function Unprotect-String {
  [CmdletBinding()] param([Parameter(Mandatory)][psobject]$Encrypted)
  switch($Encrypted.alg){ 'CMS'{ return (Unprotect-CmsMessage -Content $Encrypted.value) } 'DPAPIUser'{ $sec = ConvertTo-SecureString -String $Encrypted.value; $b = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec); try { return [Runtime.InteropServices.Marshal]::PtrToStringUni($b) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($b) } } default{ throw "Unknown alg: $($Encrypted.alg)" } }
}
