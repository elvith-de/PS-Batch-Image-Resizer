$version = "0.1 alpha"
$defaultWidthPixel = 1920
$defaultHeightPixel = 1080
$defaultSizePercent = 50
$ignoreList = @("Thumbs.db","*.cr2")

Add-Type -AssemblyName System.Windows.Forms
$textBoxLog = New-Object system.windows.Forms.TextBox
$imageMagickDir = Join-Path -Path $PSScriptRoot -ChildPath "bin\"

function Show-Form {
$FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

$form = New-Object system.Windows.Forms.Form
$form.Text = "Der saubere Bildverkleinerer ;-) ($version)"
$form.TopMost = $true
$form.Width = 598
$form.Height = 852
$form.Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")

$textBoxSourceDir = New-Object system.windows.Forms.TextBox
$textBoxSourceDir.Width = 317
$textBoxSourceDir.Height = 20
$textBoxSourceDir.location = new-object system.drawing.point(113,31)
$textBoxSourceDir.Font = "Microsoft Sans Serif,10"
$form.controls.Add($textBoxSourceDir)

$labelSourceDir = New-Object system.windows.Forms.Label
$labelSourceDir.Text = "Quellverzeichnis"
$labelSourceDir.AutoSize = $true
$labelSourceDir.Width = 25
$labelSourceDir.Height = 10
$labelSourceDir.location = new-object system.drawing.point(9,34)
$labelSourceDir.Font = "Microsoft Sans Serif,10"
$form.controls.Add($labelSourceDir)

$buttonChooseSourceDir = New-Object system.windows.Forms.Button
$buttonChooseSourceDir.Text = "Auswählen"
$buttonChooseSourceDir.Width = 85
$buttonChooseSourceDir.Height = 30
$buttonChooseSourceDir.location = new-object system.drawing.point(442,28)
$buttonChooseSourceDir.Font = "Microsoft Sans Serif,10"
$buttonChooseSourceDir.Add_Click({
    [void]$FolderBrowser.ShowDialog()
    $textBoxSourceDir.Text = $FolderBrowser.SelectedPath
})
$form.controls.Add($buttonChooseSourceDir)

$labelTargetDir = New-Object system.windows.Forms.Label
$labelTargetDir.Text = "Zielverzeichnis"
$labelTargetDir.AutoSize = $true
$labelTargetDir.Width = 25
$labelTargetDir.Height = 10
$labelTargetDir.location = new-object system.drawing.point(9,100)
$labelTargetDir.Font = "Microsoft Sans Serif,10"
$form.controls.Add($labelTargetDir)

$textBoxTargetDir = New-Object system.windows.Forms.TextBox
$textBoxTargetDir.Width = 317
$textBoxTargetDir.Height = 20
$textBoxTargetDir.enabled = $false
$textBoxTargetDir.location = new-object system.drawing.point(114,100)
$textBoxTargetDir.Font = "Microsoft Sans Serif,10"
$form.controls.Add($textBoxTargetDir)

$buttonChooseTargetDir = New-Object system.windows.Forms.Button
$buttonChooseTargetDir.Text = "Auswählen"
$buttonChooseTargetDir.Width = 85
$buttonChooseTargetDir.Height = 30
$buttonChooseTargetDir.enabled = $false
$buttonChooseTargetDir.location = new-object system.drawing.point(442,100)
$buttonChooseTargetDir.Font = "Microsoft Sans Serif,10"
$buttonChooseTargetDir.Add_Click({
    [void]$FolderBrowser.ShowDialog()
    $textBoxTargetDir.Text = $FolderBrowser.SelectedPath
})
$form.controls.Add($buttonChooseTargetDir)

$labelPrefix = New-Object system.windows.Forms.Label
$labelPrefix.Text = "(optional) Präfix für Zieldateinamen"
$labelPrefix.AutoSize = $true
$labelPrefix.Width = 25
$labelPrefix.Height = 10
$labelPrefix.location = new-object system.drawing.point(8,145)
$labelPrefix.Font = "Microsoft Sans Serif,10"
$form.controls.Add($labelPrefix)

$textBoxPrefix = New-Object system.windows.Forms.TextBox
$textBoxPrefix.Width = 100
$textBoxPrefix.Height = 20
$textBoxPrefix.location = new-object system.drawing.point(230,145)
$textBoxPrefix.Font = "Microsoft Sans Serif,10"
$textBoxPrefix.Enabled = $false
$form.controls.Add($textBoxPrefix)

$checkBoxOverwrite = New-Object system.windows.Forms.CheckBox
$checkBoxOverwrite.Text = "Bilder überschreiben"
$checkBoxOverwrite.AutoSize = $true
$checkBoxOverwrite.Width = 95
$checkBoxOverwrite.Height = 20
$checkBoxOverwrite.Checked = $true
$checkBoxOverwrite.Add_CheckStateChanged({
    $textBoxTargetDir.Enabled = -not $checkBoxOverwrite.Checked
    $buttonChooseTargetDir.Enabled = -not $checkBoxOverwrite.Checked
    $textBoxPrefix.Enabled =  -not $checkBoxOverwrite.Checked
})
$checkBoxOverwrite.location = new-object system.drawing.point(10,68)
$checkBoxOverwrite.Font = "Microsoft Sans Serif,10"
$form.controls.Add($checkBoxOverwrite)

$radioButtonPixel = New-Object system.windows.Forms.RadioButton
$radioButtonPixel.Text = "Pixel"
$radioButtonPixel.AutoSize = $true
$radioButtonPixel.Width = 104
$radioButtonPixel.Height = 20
$radioButtonPixel.location = new-object system.drawing.point(12,185)
$radioButtonPixel.Font = "Microsoft Sans Serif,10"
$radioButtonPixel.Checked = $true
$form.controls.Add($radioButtonPixel)

$textBoxWidthPixel = New-Object system.windows.Forms.TextBox
$textBoxWidthPixel.Text = $defaultWidthPixel
$textBoxWidthPixel.Width = 100
$textBoxWidthPixel.Height = 20
$textBoxWidthPixel.location = new-object system.drawing.point(80,185)
$textBoxWidthPixel.Font = "Microsoft Sans Serif,10"
$form.controls.Add($textBoxWidthPixel)

$label12 = New-Object system.windows.Forms.Label
$label12.Text = "x"
$label12.AutoSize = $true
$label12.Width = 25
$label12.Height = 10
$label12.location = new-object system.drawing.point(185,185)
$label12.Font = "Microsoft Sans Serif,10"
$form.controls.Add($label12)

$textBoxHeightPixel = New-Object system.windows.Forms.TextBox
$textBoxHeightPixel.Text = $defaultHeightPixel
$textBoxHeightPixel.Width = 100
$textBoxHeightPixel.Height = 20
$textBoxHeightPixel.location = new-object system.drawing.point(197,185)
$textBoxHeightPixel.Font = "Microsoft Sans Serif,10"
$form.controls.Add($textBoxHeightPixel)

$radioButtonPercent = New-Object system.windows.Forms.RadioButton
$radioButtonPercent.Text = "Prozent"
$radioButtonPercent.AutoSize = $true
$radioButtonPercent.Width = 104
$radioButtonPercent.Height = 20
$radioButtonPercent.location = new-object system.drawing.point(9,314)
$radioButtonPercent.Font = "Microsoft Sans Serif,10"
$form.controls.Add($radioButtonPercent)

$textBoxPercent = New-Object system.windows.Forms.TextBox
$textBoxPercent.Text = $defaultSizePercent
$textBoxPercent.Width = 100
$textBoxPercent.Height = 20
$textBoxPercent.location = new-object system.drawing.point(80,313)
$textBoxPercent.Font = "Microsoft Sans Serif,10"
$form.controls.Add($textBoxPercent)

$label19 = New-Object system.windows.Forms.Label
$label19.Text = "Es ist ausreichend, einen der Pixelwerte einzugeben. die Fehlende Angabe wird `nggf. automatisch aus der Breite/Höhe und dem Seitenverhältnis des Bildes berechnet"
$label19.AutoSize = $true
$label19.Width = 25
$label19.Height = 10
$label19.location = new-object system.drawing.point(11,215)
$label19.Font = "Microsoft Sans Serif,10"
$form.controls.Add($label19)

$label20 = New-Object system.windows.Forms.Label
$label20.Text = "Bei Angabe beider Werte wird das Bild so eingepasst, dass keine Seite die `ngewählte Breite/Höhe überschreitet"
$label20.AutoSize = $true
$label20.Width = 25
$label20.Height = 10
$label20.location = new-object system.drawing.point(11,258)
$label20.Font = "Microsoft Sans Serif,10"
$form.controls.Add($label20)

$buttonGo = New-Object system.windows.Forms.Button
$buttonGo.Text = "Los!"
$buttonGo.Width = 548
$buttonGo.Height = 33
$buttonGo.Add_Click({
    $buttonGo.Enabled = $false

    pushd

    Write-Log "------------------------------------------------------------"
    Write-Log " "

    $mode = "Pixel"
    if($radioButtonPercent.Checked)
    {
        $mode = "Percentage"
    }
    try{
        if($textBoxSourceDir.Text -eq ""){
            throw "Es wurde kein Quellpfad eingegeben!"
        }
        if(-not (Test-Path -PathType Container $textBoxSourceDir.Text)){
            throw "Quellpfad existiert nicht!"
        }
        $targetDir = $textBoxTargetDir.Text
        if($checkBoxOverwrite.Checked){
            $targetDir = " "
        }
        if($targetDir -eq "" -and $checkBoxOverwrite.Checked -eq $false){
            throw "Es wurde kein Zielpfad eingegeben!"
        }
        if(-not (Test-Path -PathType Container $targetDir) -and $checkBoxOverwrite.Checked -eq $false){
            throw "Zielpfad existiert nicht!"
        }
        Start-ImageResizeBatch -SourceDir $textBoxSourceDir.Text -TargetDir $targetDir -Overwrite $checkBoxOverwrite.Checked -Prefix $textBoxPrefix.Text -Mode $mode -PixelWidth $textBoxWidthPixel.Text -PixelHeight $textBoxHeightPixel.Text -Percentage $textBoxPercent.Text
    } catch {
        Write-Log $_.Exception.Message
        Write-Log "Es ist ein Fehler aufgetreten:"
    }

    popd
    
    $buttonGo.Enabled = $true
})
$buttonGo.location = new-object system.drawing.point(11,356)
$buttonGo.Font = "Microsoft Sans Serif,10"
$form.controls.Add($buttonGo)

$textBoxLog.Multiline = $true
$textBoxLog.Width = 552
$textBoxLog.Height = 394
$textBoxLog.location = new-object system.drawing.point(10,404)
$textBoxLog.Font = "Microsoft Sans Serif,10"
$textBoxLog.WordWrap = $true
$textBoxLog.ScrollBars = 'Both'
$form.controls.Add($textBoxLog)

$label25 = New-Object system.windows.Forms.Label
$label25.Text = "%"
$label25.AutoSize = $true
$label25.Width = 25
$label25.Height = 10
$label25.location = new-object system.drawing.point(180,313)
$label25.Font = "Microsoft Sans Serif,10"
$form.controls.Add($label25)

[void]$form.ShowDialog()
$form.Dispose()
}

function Start-ImageResizeBatch {
    [CmdletBinding()]

    param(
    [String]
    [ValidateScript({Test-Path -PathType Container $_})]
    [Parameter(Mandatory=$true)]
    $SourceDir,
    [String]
    [ValidateScript({(Test-Path -PathType Container $_) -or ($_ -eq "") -or ($_ -eq $null)})]
    $TargetDir,
    [Boolean]
    [Parameter(Mandatory=$true)]
    $Overwrite,
    [String]
    $Prefix,
    [String]
    [ValidateSet("Pixel","Percentage")]
    $Mode,
    [Int]
    $PixelWidth,
    [Int]
    $PixelHeight,
    [Int]
    $Percentage
    )

    Set-Location $imageMagickDir
    $newSize = ""
        if($mode -eq "Pixel"){
            if($PixelWidth -gt 0 -and $PixelHeight -gt 0){
                $newSize = "$($PixelWidth)x$($PixelHeight)"
            } elseif($PixelWidth -gt 0 -and $PixelHeight -le 0){
                $newSize = "$($PixelWidth)"
            } elseif($PixelWidth -le 0 -and $PixelHeight -gt 0){
                $newSize = "x$($PixelHeight)"
            } else {
                throw "Es muss mindestens eine Größenangabe > 0 Pixel angegeben werden!"
            }
        } else {
            if($Percentage -gt 0){
                $newSize = "$($Percentage)%"
            } else {
                throw "Die Prozentzahl muss > 0 sein!"
            }
        }


    Write-Log "Start Stapelverarbeitung...."
    Get-ChildItem $SourceDir -Exclude $ignoreList | Where-Object {-not $_.PSIsContainer} | Foreach-Object {
        
        Write-Log "Verarbeite $($_.Name)"

        if($Overwrite){
            .\mogrify -resize "$newSize" "$($_.FullName)"
        } else {
            $newFile = Join-Path -Path $TargetDir -ChildPath "$Prefix$($_.Name)"
            if(Test-Path $newFile -PathType Leaf){
                Write-Log "Überspringe $($_.Name): Zieldatei $newFile existiert und wird nicht überschrieben!" 
            } else {
                .\convert "$($_.Fullname)" -resize "$newSize" "$newfile"
            }
        }

    }
    Write-Log "Ende Stapelverarbeitung...."
}

function Write-Log {
    [CmdletBinding()]
    param(
    [String]
    [Parameter(Mandatory=$true)]
    $LogLine)

    $textBoxLog.Text = "[$(Get-Date -UFormat %T)] $($LogLine)$([System.Environment]::NewLine)$($textBoxLog.Text)"

}

Show-Form