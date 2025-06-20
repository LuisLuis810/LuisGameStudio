Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$admins = @{
    "ownerUser" = "Owner"
    "adminUser" = "Admin"
    "modUser" = "Moderator"
}

$currentUser = ""

function Show-LoginForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Login - Luis Game Studio"
    $form.Size = New-Object System.Drawing.Size(350, 200)
    $form.StartPosition = 'CenterScreen'

    $labelUser = New-Object System.Windows.Forms.Label -Property @{Text="Username:"; Location=(New-Object Drawing.Point(20,20)); AutoSize=$true}
    $txtUser = New-Object System.Windows.Forms.TextBox -Property @{Location=(New-Object Drawing.Point(20,45)); Width=280}

    $btnLogin = New-Object System.Windows.Forms.Button -Property @{Text="Login"; Location=(New-Object Drawing.Point(20,80)); Width=280}

    $form.Controls.AddRange(@($labelUser, $txtUser, $btnLogin))

    $btnLogin.Add_Click({
        if ($txtUser.Text.Trim() -eq "") {
            [System.Windows.Forms.MessageBox]::Show("Please enter username.","Error","OK","Error")
            return
        }
        $global:currentUser = $txtUser.Text.Trim()
        $form.Close()
        ShowMainWindow
    })

    $form.ShowDialog()
}

function ShowMainWindow {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Luis Game Studio - Fake Dev Tool"
    $form.Size = New-Object System.Drawing.Size(800, 600)
    $form.StartPosition = 'CenterScreen'
    $form.BackColor = [System.Drawing.Color]::White

    $treeView = New-Object System.Windows.Forms.TreeView
    $treeView.Location = New-Object System.Drawing.Point(10,10)
    $treeView.Size = New-Object System.Drawing.Size(250,540)

    $workspace = New-Object System.Windows.Forms.TreeNode("Workspace")
    $serverScriptService = New-Object System.Windows.Forms.TreeNode("ServerScriptService")

    $sword1 = New-Object System.Windows.Forms.TreeNode("Sword1 (Tool)")
    $sword2 = New-Object System.Windows.Forms.TreeNode("Sword2 (Tool)")
    $workspace.Nodes.Add($sword1)
    $workspace.Nodes.Add($sword2)

    $script = New-Object System.Windows.Forms.TreeNode("Script1 (Script)")
    $moduleScript = New-Object System.Windows.Forms.TreeNode("ModuleScript1 (ModuleScript)")
    $localScript = New-Object System.Windows.Forms.TreeNode("LocalScript1 (LocalScript)")
    $serverScriptService.Nodes.Add($script)
    $serverScriptService.Nodes.Add($moduleScript)
    $serverScriptService.Nodes.Add($localScript)

    $treeView.Nodes.Add($workspace)
    $treeView.Nodes.Add($serverScriptService)
    $form.Controls.Add($treeView)

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Location = New-Object System.Drawing.Point(270, 10)
    $panel.Size = New-Object System.Drawing.Size(510, 540)
    $form.Controls.Add($panel)

    $labelUser = New-Object System.Windows.Forms.Label
    $rank = if ($admins.ContainsKey($currentUser)) { $admins[$currentUser] } else { "Player" }
    $labelUser.Text = "Logged in as: $currentUser (`"$rank`")"
    $labelUser.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
    $labelUser.AutoSize = $true
    $labelUser.Location = New-Object System.Drawing.Point(10,10)
    $panel.Controls.Add($labelUser)

    $chatLog = New-Object System.Windows.Forms.TextBox
    $chatLog.Multiline = $true
    $chatLog.ReadOnly = $true
    $chatLog.ScrollBars = 'Vertical'
    $chatLog.Location = New-Object System.Drawing.Point(10, 40)
    $chatLog.Size = New-Object System.Drawing.Size(490, 400)
    $panel.Controls.Add($chatLog)

    $chatBox = New-Object System.Windows.Forms.TextBox
    $chatBox.Location = New-Object System.Drawing.Point(10, 450)
    $chatBox.Size = New-Object System.Drawing.Size(490, 25)
    $panel.Controls.Add($chatBox)

    $btnSend = New-Object System.Windows.Forms.Button
    $btnSend.Text = "Send"
    $btnSend.Location = New-Object System.Drawing.Point(410, 480)
    $btnSend.Size = New-Object System.Drawing.Size(90, 30)
    $panel.Controls.Add($btnSend)

    $btnSend.Add_Click({
        $msg = $chatBox.Text.Trim()
        if ($msg -eq "") { return }

        $chatLog.AppendText("$currentUser: $msg`r`n")

        $userRank = if ($admins.ContainsKey($currentUser)) { $admins[$currentUser] } else { "Player" }

        if ($msg.StartsWith("/kick ") -and ($userRank -eq "Admin" -or $userRank -eq "Owner")) {
            $target = $msg.Substring(6)
            $chatLog.AppendText("System: Kicked user '$target'.`r`n")
        }
        elseif ($msg.StartsWith("/ban ") -and $userRank -eq "Owner") {
            $target = $msg.Substring(5)
            $chatLog.AppendText("System: Banned user '$target'.`r`n")
        }
        elseif ($msg.StartsWith("/mods") -and ($userRank -in @("Moderator","Admin","Owner"))) {
            $chatLog.AppendText("System: Moderators online: modUser, adminUser, ownerUser.`r`n")
        }
        else {
            if ($msg.StartsWith("/")) {
                $chatLog.AppendText("System: Unknown command or insufficient permissions.`r`n")
            }
        }
        $chatBox.Clear()
    })

    $form.Topmost = $true
    $form.ShowDialog()
}

Show-LoginForm
