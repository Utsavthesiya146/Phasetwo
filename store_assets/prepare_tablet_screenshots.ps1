Add-Type -AssemblyName System.Drawing

$baseDir = "F:\phasetwo\store_assets\screenshots"
$tab7Dir = Join-Path $baseDir "tablet_7inch"
$tab10Dir = Join-Path $baseDir "tablet_10inch"

if (-not (Test-Path $tab7Dir)) { New-Item -ItemType Directory -Path $tab7Dir | Out-Null }
if (-not (Test-Path $tab10Dir)) { New-Item -ItemType Directory -Path $tab10Dir | Out-Null }

$files = Get-ChildItem -Path $baseDir -Filter "0*.png" -File

foreach ($file in $files) {
    # 7-inch tablet: 1080 x 1920 is exactly 9:16 aspect ratio (320px to 3840px)
    $dest7 = Join-Path $tab7Dir $file.Name
    Copy-Item $file.FullName -Destination $dest7 -Force
    Write-Host "Created 7-inch screenshot: $dest7"

    # 10-inch tablet: 1440 x 2560 is 9:16 aspect ratio (exceeds 1080px minimum on both sides, safely within 7680px)
    $srcImg = [System.Drawing.Bitmap]::FromFile($file.FullName)
    $dest10Bitmap = New-Object System.Drawing.Bitmap 1440, 2560
    $g = [System.Drawing.Graphics]::FromImage($dest10Bitmap)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($srcImg, 0, 0, 1440, 2560)
    
    $dest10 = Join-Path $tab10Dir $file.Name
    $dest10Bitmap.Save($dest10, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $dest10Bitmap.Dispose()
    $srcImg.Dispose()
    Write-Host "Created 10-inch screenshot (1440x2560): $dest10"
}

Write-Host "All tablet screenshots generated successfully!"
