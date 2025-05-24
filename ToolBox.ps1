Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "All-in-One Windows Toolkit"
$form.Size = New-Object System.Drawing.Size(500, 700)
$form.StartPosition = "CenterScreen"
$form.BackColor = "WhiteSmoke"

# Function to create buttons
function Add-Button($text, $top, $clickHandler) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $text
    $button.Size = New-Object System.Drawing.Size(440, 30)
    $button.Location = New-Object System.Drawing.Point(20, $top)
    $button.Add_Click($clickHandler)
    $form.Controls.Add($button)
}

# Define actions
$actions = [ordered]@{
    "Clear Temp Files" = { Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue; [System.Windows.Forms.MessageBox]::Show("Temp files cleared.") }
    "Run Disk Cleanup" = { Start-Process "cleanmgr.exe" }
    "Backup Documents" = { Copy-Item "$env:USERPROFILE\Documents\*" "$env:USERPROFILE\Desktop\Documents_Backup" -Recurse -Force; [System.Windows.Forms.MessageBox]::Show("Backup complete.") }
    "Show System Info" = { systeminfo > "$env:USERPROFILE\Desktop\systeminfo.txt"; [System.Windows.Forms.MessageBox]::Show("System info saved to Desktop.") }
    "List Installed Programs" = { wmic product get name > "$env:USERPROFILE\Desktop\installed_programs.txt"; [System.Windows.Forms.MessageBox]::Show("Program list saved to Desktop.") }
    "Generate Battery Report" = { powercfg /batteryreport /output "$env:USERPROFILE\Desktop\battery_report.html"; [System.Windows.Forms.MessageBox]::Show("Battery report saved to Desktop.") }
    "Open Websites" = { Start-Process "https://www.google.com"; Start-Process "https://github.com"; Start-Process "https://www.youtube.com" }
    "Log Login Time" = { "$env:USERNAME logged in at $(Get-Date)" >> "$env:USERPROFILE\login_log.txt"; [System.Windows.Forms.MessageBox]::Show("Login logged.") }
    "Rename Files in Folder" = {
        $i = 1
        Get-ChildItem "$env:USERPROFILE\Documents" | ForEach-Object {
            Rename-Item $_.FullName -NewName ("File_$i$($_.Extension)")
            $i++
        }
        [System.Windows.Forms.MessageBox]::Show("Files renamed.")
    }
    "Check Internet Connection" = {
        if (Test-Connection google.com -Count 1 -Quiet) {
            [System.Windows.Forms.MessageBox]::Show("Internet is available.")
        } else {
            [System.Windows.Forms.MessageBox]::Show("No internet connection.")
        }
    }
    "Delete Old Files (Downloads 30+ Days)" = {
        Get-ChildItem "$env:USERPROFILE\Downloads" -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force -Recurse
        [System.Windows.Forms.MessageBox]::Show("Old files deleted.")
    }
    "Create Dated Folder" = {
        $folderName = Get-Date -Format "yyyy-MM-dd"
        New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents\$folderName" -Force
        [System.Windows.Forms.MessageBox]::Show("Dated folder created.")
    }
    "Zip Documents Folder" = {
        Compress-Archive -Path "$env:USERPROFILE\Documents\*" -DestinationPath "$env:USERPROFILE\Desktop\Documents.zip" -Force
        [System.Windows.Forms.MessageBox]::Show("Documents folder zipped.")
    }
    "Show System Uptime" = {
        $uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
        [System.Windows.Forms.MessageBox]::Show("System uptime since: $uptime")
    }
    "Simulate Typing" = {
        $msg = "Hello, this is being typed..."
        foreach ($char in $msg.ToCharArray()) {
            [System.Windows.Forms.SendKeys]::SendWait($char)
            Start-Sleep -Milliseconds 100
        }
	}
"Exit from Tool" = {$form.Close()}

    
}

# Create buttons
$top = 20
foreach ($key in $actions.Keys) {
    Add-Button $key $top $actions[$key]
    $top += 35
}


# Show form
[void]$form.ShowDialog()
