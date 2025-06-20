Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Downloading... Please wait.","Download Screen","OK","Information")
Start-Sleep -Seconds 5
Write-Output "Download complete!"
