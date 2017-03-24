$imFile = "ImageMagick-7.0.5-3-portable-Q16-x64.zip"
$imURI = "https://www.imagemagick.org/download/binaries/$imFile"
$zipPath = Join-Path -Path $PSScriptRoot -ChildPath $imFile
$binPath = Join-Path -Path $PSScriptRoot -ChildPath "bin"

Add-Type -AssemblyName System.Windows.Forms

Write-Host "Checking for bin\ folder"
if(-not (Test-Path $binPath)){
    Write-Host "Creating bin\ folder"
    New-Item -ItemType Directory -Path $binPath | Out-Null
}

if(-not(Test-Path -Path (Join-Path -Path $binPath -ChildPath "mogrify.exe") -PathType Leaf) -or -not(Test-Path -Path (Join-Path -Path $binPath -ChildPath "convert.exe") -PathType Leaf)){

    Write-Host "ImageMagick not found, downloading $imURI..."
    Invoke-WebRequest -OutFile $zipPath -Uri $imURI

    Write-Host "Extracting $imFile..."
    Add-Type -assembly “system.io.compression.filesystem”
    [io.compression.zipfile]::ExtractToDirectory($zipPath, $binPath)

    Write-Host "Removing unneeded subfolders from ImageMagick Portable..."
    Get-ChildItem $binPath | Where-Object {$_.PSIsContainer} | ForEach-Object {Remove-Item $_.FullName -Recurse}

    Write-Host "Removing $zipPath..."
    Remove-Item $zipPath


    $Result = [System.Windows.Forms.MessageBox]::Show("Setup beendet!","Fertig",0,[System.Windows.Forms.MessageBoxIcon]::Information)
}
