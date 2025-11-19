function Set-MDABranding {
  [CmdletBinding()] param([string]$BrandName='Lutech',[string]$PrimaryColor,[string]$SecondaryColor,[string]$AccentColor,[int]$LogoHeightPx=32,[string]$LogoPath,[ValidateSet('image/png','image/jpeg','image/svg+xml')][string]$LogoMime)
  if ($BrandName){ $script:MDA_Brand.Name = $BrandName }
  if ($PrimaryColor){ $script:MDA_Brand.PrimaryColor = $PrimaryColor }
  if ($SecondaryColor){ $script:MDA_Brand.SecondaryColor = $SecondaryColor }
  if ($AccentColor){ $script:MDA_Brand.AccentColor = $AccentColor }
  if ($LogoHeightPx){ $script:MDA_Brand.LogoHeightPx = $LogoHeightPx }
  if ($LogoMime){ $script:MDA_Brand.LogoMime = $LogoMime }
  if ($LogoPath -and (Test-Path $LogoPath)){
    $bytes = [IO.File]::ReadAllBytes((Resolve-Path $LogoPath)); $script:MDA_Brand.LogoBase64 = [Convert]::ToBase64String($bytes)
    if (-not $LogoMime){ switch ([IO.Path]::GetExtension($LogoPath).ToLower()){ '.png' { $script:MDA_Brand.LogoMime = 'image/png' }; '.jpg' { $script:MDA_Brand.LogoMime = 'image/jpeg' }; '.jpeg'{ $script:MDA_Brand.LogoMime = 'image/jpeg' }; '.svg' { $script:MDA_Brand.LogoMime = 'image/svg+xml' } } }
    Write-Log -Message ("Brand logo loaded: " + (Resolve-Path $LogoPath)) -Level INFO
  }
}
