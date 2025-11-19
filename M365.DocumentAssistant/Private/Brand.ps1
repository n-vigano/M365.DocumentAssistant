if (-not $script:MDA_Brand) {
  $script:MDA_Brand = [ordered]@{ Name='Lutech'; PrimaryColor='#D0021B'; SecondaryColor='#343434'; AccentColor='#E5E5E5'; FontFamily="'Montserrat',Segoe UI,Arial,Helvetica,sans-serif"; LogoBase64=$null; LogoMime='image/png'; LogoHeightPx=32 }
}
function Get-MDABrandCss {
  $p=$script:MDA_Brand.PrimaryColor; $s=$script:MDA_Brand.SecondaryColor; $a=$script:MDA_Brand.AccentColor; $ff=$script:MDA_Brand.FontFamily
  @":root{--mdl-primary:$p;--mdl-secondary:$s;--mdl-accent:$a;--mdl-font:$ff}body{font-family:var(--mdl-font);background:#f9fbfd;color:#1b1b1b;margin:24px}.header{display:flex;align-items:center;gap:12px;margin-bottom:16px}.header .title{color:var(--mdl-secondary);font-size:24px;font-weight:600}.card{background:#fff;border-radius:10px;box-shadow:0 2px 8px rgba(0,0,0,.08);padding:24px;margin-bottom:18px}.table{border-collapse:collapse;width:100%}.table th,.table td{border:1px solid #eaeaea;padding:8px}.table th{background:#fafafa;text-align:left;color:#333}footer{margin-top:20px;color:#666;font-size:12px}hr.brand{border:0;border-top:3px solid var(--mdl-primary);margin:8px 0 16px}"@
}
function Get-MDABrandLogoTag { if ($script:MDA_Brand.LogoBase64){ $mime=$script:MDA_Brand.LogoMime; $h=[int]$script:MDA_Brand.LogoHeightPx; return "<img alt='"+$script:MDA_Brand.Name+" logo' style='height:"+$h+"px' src='data:"+$mime+";base64,"+$script:MDA_Brand.LogoBase64+"'/>" } return '' }
