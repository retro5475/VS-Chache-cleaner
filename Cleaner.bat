@echo off
setlocal

:: Set the path to Visual Studio executable (modify if necessary)
set "vsPath=C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"

:: Create PowerShell commands for cache reset and GUI
set "psCommand=Add-Type -AssemblyName System.Windows.Forms; " ^
    "Add-Type -AssemblyName System.Drawing; " ^
    "$form = New-Object System.Windows.Forms.Form; " ^
    "$form.Text = 'Visual Studio Cache Reset'; " ^
    "$form.Size = New-Object System.Drawing.Size(400, 200); " ^
    "$form.StartPosition = 'CenterScreen'; " ^
    "$label = New-Object System.Windows.Forms.Label; " ^
    "$label.Text = 'Cache is being reset...'; " ^
    "$label.AutoSize = $true; " ^
    "$label.Location = New-Object System.Drawing.Point(10, 20); " ^
    "$form.Controls.Add($label); " ^
    "$progressBar = New-Object System.Windows.Forms.ProgressBar; " ^
    "$progressBar.Location = New-Object System.Drawing.Point(10, 50); " ^
    "$progressBar.Size = New-Object System.Drawing.Size(360, 30); " ^
    "$form.Controls.Add($progressBar); " ^
    "$form.Show(); " ^
    "$paths = @('%LocalAppData%\\Microsoft\\VisualStudio\\17.0_*', '%LocalAppData%\\Microsoft\\VSCommon', '%AppData%\\Microsoft\\VisualStudio\\17.0_*', '%LocalAppData%\\Temp\\VisualStudio*'); " ^
    "foreach ($path in $paths) { " ^
    "    $progressBar.Value += 25; " ^
    "    $label.Text = 'Delete $path...'; " ^
    "    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue; " ^
    "    Start-Sleep -Seconds 2; " ^
    "} " ^
    "$label.Text = 'Done... Cache reset complete!'; " ^
    "$progressBar.Value = 100; " ^
    "Start-Sleep -Seconds 2; " ^
    "$form.Close();"

:: Start PowerShell with the constructed command
start powershell -NoExit -Command "%psCommand%; Start-Process '%vsPath%'; exit"

:: Wait for the PowerShell to complete before exiting the batch file
timeout /t 10 >nul
exit
