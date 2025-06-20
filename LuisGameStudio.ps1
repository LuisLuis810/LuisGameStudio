Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.MessageBox]::Show("Publisher: LuisLuis810`nVersion: 1.0", "Luis Game Studio", 'OK', 'Information')

function GlobalErrorHandler {
    param($errorMessage)
    [System.Windows.Forms.MessageBox]::Show("An error occurred:`n$errorMessage", "Error", 'OK', 'Error')
}

try {
    # Your main code below (replace with your existing script body)
    # Example:
    Show-LoginForm
}
catch {
    GlobalErrorHandler $_.Exception.Message
}
