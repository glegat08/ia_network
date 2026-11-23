# downloads the prebuilt opencv 5.1.0 for windows and extracts it into external/opencv
# run once after cloning: powershell -ExecutionPolicy Bypass -File setup_opencv.ps1

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$OPENCV_VERSION = "5.1.0"
$OPENCV_URL = "https://github.com/opencv/opencv/releases/download/$OPENCV_VERSION/opencv-$OPENCV_VERSION-windows.exe"
$OPENCV_SHA256 = "7F3365154DCC3543EB75855E9DD1E144E94C7F666BE16ED2E563FAA5D93B0B7B"

$external_directory = Join-Path $PSScriptRoot "external"
$opencv_directory = Join-Path $external_directory "opencv"
$installer_path = Join-Path $env:TEMP "opencv-$OPENCV_VERSION-windows.exe"

# already installed => nothing to do
if (Test-Path (Join-Path $opencv_directory "build\include\opencv2\core.hpp"))
{
    Write-Host "opencv $OPENCV_VERSION is already in $opencv_directory"
    exit 0
}

New-Item -ItemType Directory -Force $external_directory | Out-Null

Write-Host "downloading opencv $OPENCV_VERSION (about 200 MB)..."
Invoke-WebRequest -Uri $OPENCV_URL -OutFile $installer_path

# corrupted or replaced download => stop before running it
$downloaded_hash = (Get-FileHash $installer_path -Algorithm SHA256).Hash

if ($downloaded_hash -ne $OPENCV_SHA256)
{
    Remove-Item $installer_path -Force
    throw "checksum mismatch for $installer_path (got $downloaded_hash)"
}

# short temporary folder => no path longer than 260 characters inside the archive
$extraction_directory = Join-Path $env:TEMP "ocv$OPENCV_VERSION"

if (Test-Path $extraction_directory)
{
    Remove-Item $extraction_directory -Recurse -Force
}

Write-Host "extracting..."
$extraction = Start-Process -FilePath $installer_path -ArgumentList "-o`"$extraction_directory`"", "-y" -Wait -PassThru

Remove-Item $installer_path -Force

$extracted_build = Join-Path $extraction_directory "opencv\build"

if (-not (Test-Path (Join-Path $extracted_build "include\opencv2\core.hpp")))
{
    throw "extraction failed (exit code $($extraction.ExitCode))"
}

# only build/ and the licenses are needed, not the sources
New-Item -ItemType Directory -Force $opencv_directory | Out-Null
Move-Item $extracted_build $opencv_directory
Move-Item (Join-Path $extraction_directory "opencv\LICENSE*.txt") $opencv_directory -Force

Remove-Item $extraction_directory -Recurse -Force

Write-Host "opencv $OPENCV_VERSION is ready in $opencv_directory"
