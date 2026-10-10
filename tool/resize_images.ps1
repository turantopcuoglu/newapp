# Resizes delivered artwork for bundling: longest side <= MaxSide, JPEG.
#
# GPT image output is 1-3 MB PNG; bundled as-is, 30 images would add ~60 MB
# to the app. At 1200 px / quality 85 a cover is ~150-250 KB and still sharp
# on a 3x phone at card size.
#
# Usage (from the repo root):
#   powershell -ExecutionPolicy Bypass -File tool/resize_images.ps1 `
#     -Source docs/design/gorsel-uretim/teslim -Target assets/images/explore `
#     -Filter "cuisine_*.png"
param(
  [Parameter(Mandatory = $true)][string]$Source,
  [Parameter(Mandatory = $true)][string]$Target,
  [string]$Filter = "*.png",
  [int]$MaxSide = 1200,
  [int]$Quality = 85
)

Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force -Path $Target | Out-Null

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
  Where-Object { $_.MimeType -eq 'image/jpeg' }
$params = New-Object System.Drawing.Imaging.EncoderParameters(1)
$params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
  [System.Drawing.Imaging.Encoder]::Quality, [long]$Quality)

Get-ChildItem -Path $Source -Filter $Filter | ForEach-Object {
  $image = [System.Drawing.Image]::FromFile($_.FullName)
  try {
    $scale = [Math]::Min(1.0, $MaxSide / [Math]::Max($image.Width, $image.Height))
    $w = [int][Math]::Round($image.Width * $scale)
    $h = [int][Math]::Round($image.Height * $scale)
    $bitmap = New-Object System.Drawing.Bitmap($w, $h)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.InterpolationMode =
      [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.DrawImage($image, 0, 0, $w, $h)
    $out = Join-Path $Target ($_.BaseName + '.jpg')
    $bitmap.Save($out, $codec, $params)
    $graphics.Dispose()
    $bitmap.Dispose()
    $kb = [Math]::Round((Get-Item $out).Length / 1KB)
    Write-Output "$($_.Name) -> $out (${w}x${h}, $kb KB)"
  }
  finally {
    $image.Dispose()
  }
}
