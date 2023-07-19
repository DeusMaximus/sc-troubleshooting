# Change this value to change the default path
$strDefault = "C:\Program Files\Roberts Space Industries\StarCitizen"

# Don't change any other values
Clear-Host
Write-Host "Welcome to Deus Maximus's Star Citizen Troubleshooting script (for Alpha 3.17 or higher)."
Write-Host
$strFolder = Read-Host -Prompt "Where is your Star Citizen Folder located? (default is ""$strDefault"")"
if ($strFolder -eq ""){
    $strFolder = $strDefault
}

function Show-Menu
{
    param (
        [string]$Title = 'Star Citizen Troubleshooting'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to delete shaders."
    Write-Host "2: Press '2' to delete debug logs and log backups."
    Write-Host "3: Press '3' to delete previous crash dumps."
    Write-Host "4: Press '4' to delete Easy Anti Cheat (you will need to re-verify files after doing this)."
    Write-Host "5: Press '5' to delete the LIVE USER folder (not recommended)."
    Write-Host "6: Press '6' to delete the PTU & EPTU USER folder."
    Write-Host "7: Press '7' to prepare the public test universe."
    Write-Host "8: Press '8' to prepare the experimental public test universe."
    Write-Host "Q: Press 'Q' to quit."
}

function deleteShaders
{
    $strShaderPaths = Get-ChildItem "$env:LOCALAPPDATA\Star Citizen" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('shaders')}
    $strOldShaderPaths = Get-ChildItem "$strFolder" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('shaders')}
    
    foreach ($strShaderPath in $strShaderPaths) {
        Write-Host "Deleting shaders in" $strShaderPath.FullName
        Remove-Item $strShaderPath.FullName -Recurse
    }
    foreach ($strOldShaderPath in $strOldShaderPaths) {
        Write-Host "Deleting shaders in" $strOldShaderPath.FullName
        Remove-Item $strOldShaderPath.FullName -Recurse
    }
}

function deleteOldLogs
{
    $strLogPaths = Get-ChildItem "$strFolder" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('logbackups')}
    $strDebugLogPaths = Get-ChildItem "$strFolder" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('DebugLogs')}

    foreach ($strLogPath in $strLogPaths) {
        Write-Host "Deleting logs in" $strLogPath.FullName
        Remove-Item $strLogPath.FullName -Recurse
    }
    foreach ($strDebugLogPath in $strDebugLogPaths) {
        Write-Host "Deleting debug logs in" $strDebugLogPath.FullName
        Remove-Item $strDebugLogPath.FullName -Recurse
    }
}

function deleteCrashes
{
    $strCrashPath = "$env:LOCALAPPDATA\Star Citizen\Crashes"
    
    If (Test-Path "$strCrashPath"){
        Write-Host "Deleting crash dumps in" $strCrashPath
        Remove-Item "$strCrashPath" -Recurse
    }
}

function deleteEAC
{
    $strEACPaths = Get-ChildItem "$strFolder" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('EasyAntiCheat')}
    
    foreach ($strEACPath in $strEACPaths) {
        Write-Host "Deleting EasyAntiCheat in" $strEACPath.FullName
        Remove-Item $strEACPath.FullName -Recurse
    }
    Write-Host "Remember to verify your game files before launching Star Citizen after doing this!"
}

function deleteUser
{
    $strUserPaths = Get-ChildItem "$strFolder\LIVE" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('USER')}
    Write-Host 'This will delete all folders with USER in the name in your LIVE folder, including controller bindings.'
    $deleteUsers = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 1)
    if ($deleteUsers -eq 0)
    {
        foreach ($strUserPath in $strUserPaths) {
            Write-Host "Deleting USER folder in" $strUserPath.FullName
            Remove-Item $strUserPath.FullName -Recurse
        }
    }
}

function deleteUserPTU
{
    $strUserPTUPaths = Get-ChildItem "$strFolder\PTU" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('USER')}
    $strUserEPTUPaths = Get-ChildItem "$strFolder\EPTU" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('USER')}
    
    Write-Host 'This will delete all folders with USER in the name in your PTU and EPTU folder, including controller bindings.'
    $deleteUsersPTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deleteUsersPTU -eq 0){
        foreach ($strUserPTUPath in $strUserPTUPaths) {
            Write-Host "Deleting USER folder in" $strUserPTUPath.FullName
            Remove-Item $strUserPTUPath.FullName -Recurse
        }
        foreach ($strUserEPTUPath in $strUserEPTUPaths) {
            Write-Host "Deleting USER folder in" $strUserEPTUPath.FullName
            Remove-Item $strUserEPTUPath.FullName -Recurse
        }
    }
}

function copyPTU
{
    Write-Host 'This will delete all files in the PTU folder, except for the USER and ScreenShots folder, and copy the current LIVE build as a starting point for the next PTU patch.'
    $deletePTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deletePTU -eq 0){
        Get-ChildItem -Path  "$strFolder\PTU" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\LIVE" "$strFolder\PTU" /MIR /XD "$strFolder\LIVE\DebugLogs" "$strFolder\LIVE\EasyAntiCheat" "$strFolder\LIVE\logbackups" "$strFolder\LIVE\logs" "$strFolder\LIVE\ScreenShots" "$strFolder\LIVE\USER" /XF *.log
    }
}

function copyEPTU
{
    Write-Host 'This will delete all files in the EPTU folder, except for the USER and ScreenShots folder, and copy the current LIVE build as a starting point for the next EPTU patch.'
    $deleteEPTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deleteEPTU -eq 0){
        Get-ChildItem -Path  "$strFolder\EPTU" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\LIVE" "$strFolder\EPTU" /MIR /XD "$strFolder\LIVE\DebugLogs" "$strFolder\LIVE\EasyAntiCheat" "$strFolder\LIVE\logbackups" "$strFolder\LIVE\logs" "$strFolder\LIVE\ScreenShots" "$strFolder\LIVE\USER" /XF *.log
    }
}

do
{
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
        '1' {
            deleteShaders
        } '2' {
            deleteOldLogs
        } '3' {
            deleteCrashes
        } '4' {
            deleteEAC
        } '5' {
            deleteUser
        } '6' {
            deleteUserPTU
        } '7' {
            copyPTU
        } '8' {
            copyEPTU
        }
    }
    Write-Host
    pause
}
until ($selection -eq 'q')
Clear-Host
