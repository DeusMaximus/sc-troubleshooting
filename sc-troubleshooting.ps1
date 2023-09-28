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
    
    Write-Host "1: Press '1' for the LIVE environment."
    Write-Host "2: Press '2' for the PTU environment."
    Write-Host "3: Press '3' for the EPTU environment."
    Write-Host "4: Press '4' for general troubleshooting."
    Write-Host "Q: Press 'Q' to quit."
}

function Show-LIVE-Menu
{
    param (
        [string]$Title = 'Star Citizen LIVE Troubleshooting'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to delete Easy Anti Cheat (you will need to re-verify files after doing this)."
    Write-Host "2: Press '2' to delete the LIVE USER folder (not recommended)."
    Write-Host "3: Press '3' to copy LIVE to the PTU environment."
    Write-Host "4: Press '4' to copy LIVE to the EPTU environment."
    Write-Host "B: Press 'B' to go back."
}

function Show-PTU-Menu
{
    param (
        [string]$Title = 'Star Citizen PTU Troubleshooting'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to delete Easy Anti Cheat (you will need to re-verify files after doing this)."
    Write-Host "2: Press '2' to delete the PTU USER folder."
    Write-Host "3: Press '3' to copy PTU to the LIVE environment."
    Write-Host "4: Press '4' to copy PTU to the EPTU environment."
    Write-Host "B: Press 'B' to go back."
}

function Show-EPTU-Menu
{
    param (
        [string]$Title = 'Star Citizen EPTU Troubleshooting'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to delete Easy Anti Cheat (you will need to re-verify files after doing this)."
    Write-Host "2: Press '2' to delete the EPTU USER folder."
    Write-Host "3: Press '3' to copy EPTU to the LIVE environment."
    Write-Host "4: Press '4' to copy EPTU to the PTU environment."
    Write-Host "B: Press 'B' to go back."
}

function Show-General-Menu
{
    param (
        [string]$Title = 'Star Citizen General Troubleshooting'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to delete shaders."
    Write-Host "2: Press '2' to delete debug logs and log backups."
    Write-Host "3: Press '3' to delete previous crash dumps."
    Write-Host "B: Press 'B' to go back."
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

function deleteEAC_LIVE
{
    $strEACPaths = Get-ChildItem "$strFolder\LIVE" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('EasyAntiCheat')}
    
    foreach ($strEACPath in $strEACPaths) {
        Write-Host "Deleting EasyAntiCheat in" $strEACPath.FullName
        Remove-Item $strEACPath.FullName -Recurse
    }
    Write-Host "Remember to verify your game files before launching Star Citizen after doing this!"
}

function deleteEAC_PTU
{
    $strEACPaths = Get-ChildItem "$strFolder\PTU" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('EasyAntiCheat')}
    
    foreach ($strEACPath in $strEACPaths) {
        Write-Host "Deleting EasyAntiCheat in" $strEACPath.FullName
        Remove-Item $strEACPath.FullName -Recurse
    }
    Write-Host "Remember to verify your game files before launching Star Citizen after doing this!"
}

function deleteEAC_EPTU
{
    $strEACPaths = Get-ChildItem "$strFolder\EPTU" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('EasyAntiCheat')}
    
    foreach ($strEACPath in $strEACPaths) {
        Write-Host "Deleting EasyAntiCheat in" $strEACPath.FullName
        Remove-Item $strEACPath.FullName -Recurse
    }
    Write-Host "Remember to verify your game files before launching Star Citizen after doing this!"
}
function deleteUserLIVE
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
    
    Write-Host 'This will delete all folders with USER in the name in your PTU folder, including controller bindings.'
    $deleteUsersPTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deleteUsersPTU -eq 0){
        foreach ($strUserPTUPath in $strUserPTUPaths) {
            Write-Host "Deleting USER folder in" $strUserPTUPath.FullName
            Remove-Item $strUserPTUPath.FullName -Recurse
        }
    }
}

function deleteUserEPTU
{
    $strUserEPTUPaths = Get-ChildItem "$strFolder\EPTU" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('USER')}
    
    Write-Host 'This will delete all folders with USER in the name in your EPTU folder, including controller bindings.'
    $deleteUsersEPTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deleteUsersEPTU -eq 0){
        foreach ($strUserEPTUPath in $strUserEPTUPaths) {
            Write-Host "Deleting USER folder in" $strUserEPTUPath.FullName
            Remove-Item $strUserEPTUPath.FullName -Recurse
        }
    }
}


function copyLIVEtoPTU
{
    Write-Host 'This will delete all files in the PTU folder, except for the USER and ScreenShots folder, and copy the current LIVE build as a starting point for the next PTU patch.'
    $deletePTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deletePTU -eq 0){
        Get-ChildItem -Path  "$strFolder\PTU" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\LIVE" "$strFolder\PTU" /MIR /XD "$strFolder\LIVE\DebugLogs" "$strFolder\LIVE\EasyAntiCheat" "$strFolder\LIVE\logbackups" "$strFolder\LIVE\logs" "$strFolder\LIVE\ScreenShots" "$strFolder\LIVE\USER" /XF *.log
    }
}

function copyLIVEtoEPTU
{
    Write-Host 'This will delete all files in the EPTU folder, except for the USER and ScreenShots folder, and copy the current LIVE build as a starting point for the next EPTU patch.'
    $deleteEPTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deleteEPTU -eq 0){
        Get-ChildItem -Path  "$strFolder\EPTU" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\LIVE" "$strFolder\EPTU" /MIR /XD "$strFolder\LIVE\DebugLogs" "$strFolder\LIVE\EasyAntiCheat" "$strFolder\LIVE\logbackups" "$strFolder\LIVE\logs" "$strFolder\LIVE\ScreenShots" "$strFolder\LIVE\USER" /XF *.log
    }
}

function copyPTUtoLIVE
{
    Write-Host 'This will delete all files in the LIVE folder, except for the USER and ScreenShots folder, and copy the current PTU build as a starting point for the next LIVE patch.'
    $deletePTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deletePTU -eq 0){
        Get-ChildItem -Path  "$strFolder\LIVE" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\PTU" "$strFolder\LIVE" /MIR /XD "$strFolder\PTU\DebugLogs" "$strFolder\PTU\EasyAntiCheat" "$strFolder\PTU\logbackups" "$strFolder\PTU\logs" "$strFolder\PTU\ScreenShots" "$strFolder\PTU\USER" /XF *.log
    }
}

function copyPTUtoEPTU
{
    Write-Host 'This will delete all files in the EPTU folder, except for the USER and ScreenShots folder, and copy the current PTU build as a starting point for the next EPTU patch.'
    $deletePTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deletePTU -eq 0){
        Get-ChildItem -Path  "$strFolder\EPTU" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\PTU" "$strFolder\EPTU" /MIR /XD "$strFolder\PTU\DebugLogs" "$strFolder\PTU\EasyAntiCheat" "$strFolder\PTU\logbackups" "$strFolder\PTU\logs" "$strFolder\PTU\ScreenShots" "$strFolder\PTU\USER" /XF *.log
    }
}

function copyEPTUtoLIVE
{
    Write-Host 'This will delete all files in the LIVE folder, except for the USER and ScreenShots folder, and copy the current EPTU build as a starting point for the next LIVE patch.'
    $deletePTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deletePTU -eq 0){
        Get-ChildItem -Path  "$strFolder\LIVE" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\EPTU" "$strFolder\LIVE" /MIR /XD "$strFolder\EPTU\DebugLogs" "$strFolder\EPTU\EasyAntiCheat" "$strFolder\EPTU\logbackups" "$strFolder\EPTU\logs" "$strFolder\EPTU\ScreenShots" "$strFolder\EPTU\USER" /XF *.log
    }
}

function copyEPTUtoPTU
{
    Write-Host 'This will delete all files in the PTU folder, except for the USER and ScreenShots folder, and copy the current EPTU build as a starting point for the next PTU patch.'
    $deletePTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deletePTU -eq 0){
        Get-ChildItem -Path  "$strFolder\PTU" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\EPTU" "$strFolder\PTU" /MIR /XD "$strFolder\EPTU\DebugLogs" "$strFolder\EPTU\EasyAntiCheat" "$strFolder\EPTU\logbackups" "$strFolder\EPTU\logs" "$strFolder\EPTU\ScreenShots" "$strFolder\EPTU\USER" /XF *.log
    }
}


do
{
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
        '1' {
            do
            {
                Show-LIVE-Menu
                $selection1 = Read-Host "Please make a selection"
                switch ($selection1)
                {
                    '1' {
                        deleteEAC_LIVE
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteUserLIVE
                        Write-Host
                        pause    
                    }
                    '3' {
                        copyLIVEtoPTU
                        Write-Host
                        pause    
                    }
                    '4' {
                        copyLIVEtoEPTU
                        Write-Host
                        pause    
                    }
                }
            }
            until ($selection1 -eq 'b')
        } '2' {
            do
            {
                Show-PTU-Menu
                $selection2 = Read-Host "Please make a selection"
                switch ($selection2)
                {
                    '1' {
                        deleteEAC_PTU
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteUserPTU
                        Write-Host
                        pause    
                    }
                    '3' {
                        copyPTUtoLIVE
                        Write-Host
                        pause    
                    }
                    '4' {
                        copyPTUtoEPTU
                        Write-Host
                        pause    
                    }
                }
            }
            until ($selection2 -eq 'b')
        } '3' {
            do
            {
                Show-EPTU-Menu
                $selection3 = Read-Host "Please make a selection"
                switch ($selection3)
                {
                    '1' {
                        deleteEAC_EPTU
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteUserEPTU
                        Write-Host
                        pause    
                    }
                    '3' {
                        copyEPTUtoLIVE
                        Write-Host
                        pause    
                    }
                    '4' {
                        copyEPTUtoPTU
                        Write-Host
                        pause    
                    }
                }
            }
            until ($selection3 -eq 'b')
        } '4' {
            do
            {
                Show-General-Menu
                $selection4 = Read-Host "Please make a selection"
                switch ($selection4)
                {
                    '1' {
                        deleteShaders
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteOldLogs
                        Write-Host
                        pause    
                    }
                    '3' {
                        deleteCrashes
                        Write-Host
                        pause    
                    }
                }
            }
            until ($selection4 -eq 'b')
        }
    }
}
until ($selection -eq 'q')
Clear-Host
