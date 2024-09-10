# Change this value to change the default path
$strDefault = "C:\Program Files\Roberts Space Industries\StarCitizen"

# Don't change any other values
# $roamingAppData = [Environment]::GetFolderPath('ApplicationData')
$localAppData = [Environment]::GetFolderPath('LocalApplicationData')

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
    Write-Host "4: Press '4' for the TECH-PREVIEW environment."
    Write-Host "5: Press '5' for general troubleshooting."
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
    Write-Host "5: Press '5' to copy LIVE to the TECH-PREVIEW environment."
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
    $strShaderPaths = Get-ChildItem "$localAppData\Star Citizen" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('shaders')}
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
    $strCrashPath = "$localAppData\Star Citizen\Crashes"
    
    If (Test-Path "$strCrashPath"){
        Write-Host "Deleting crash dumps in" $strCrashPath
        Remove-Item "$strCrashPath" -Recurse
    }
}

function deleteEAC
{
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Environment
    )
    $strEACPaths = Get-ChildItem "$strFolder\$Environment" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('EasyAntiCheat')}
    
    foreach ($strEACPath in $strEACPaths) {
        Write-Host "Deleting EasyAntiCheat in" $strEACPath.FullName
        Remove-Item $strEACPath.FullName -Recurse
    }
    Write-Host "Remember to verify your game files before launching Star Citizen after doing this!"
}

function deleteUser
{
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Environment
    )
    $strUserPaths = Get-ChildItem "$strFolder\$Environment" -Recurse | Where-Object { $_.PSIsContainer -and $_.Name.EndsWith('USER')}
    Write-Host "This will delete all folders with USER in the name in your $Environment folder, including controller bindings."
    $deleteUsers = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 1)
    if ($deleteUsers -eq 0)
    {
        foreach ($strUserPath in $strUserPaths) {
            Write-Host "Deleting USER folder in" $strUserPath.FullName
            Remove-Item $strUserPath.FullName -Recurse
        }
    }
}

function copyEnvironment
{
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $Source,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $Destination
    )
    Write-Host "This will delete all files in the $Destination folder, except for the USER and ScreenShots folder, and copy the current $Source build as a starting point for the next $Destination patch."
    $deletePTU = $Host.UI.PromptForChoice('', 'Are you sure?', @('&Yes'; '&No'), 0)
    if ($deletePTU -eq 0){
        if(!(Test-Path -Path "$strFolder\$Destination"))
        {
            New-Item -Path "$strFolder" -Name "$Destination" -ItemType Directory
        }    
        Get-ChildItem -Path  "$strFolder\$Destination" -Exclude ('USER', 'ScreenShots') | Get-ChildItem -Recurse | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force 
        robocopy "$strFolder\$Source" "$strFolder\$Destination" /MIR /XD "$strFolder\$Source\DebugLogs" "$strFolder\$Source\EasyAntiCheat" "$strFolder\$Source\logbackups" "$strFolder\$Source\logs" "$strFolder\$Source\ScreenShots" "$strFolder\$Source\USER" /XF *.log
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
                        deleteEAC -Environment "LIVE"
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteUser -Environment "LIVE"
                        Write-Host
                        pause    
                    }
                    '3' {
                        copyEnvironment -Source "LIVE" -Destination "PTU"
                        Write-Host
                        pause    
                    }
                    '4' {
                        copyEnvironment -Source "LIVE" -Destination "EPTU"
                        Write-Host
                        pause    
                    }
                    '5' {
                        copyEnvironment -Source "LIVE" -Destination "TECH-PREVIEW"
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
                        deleteEAC -Environment "PTU"
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteUser -Environment "PTU"
                        Write-Host
                        pause    
                    }
                    '3' {
                        copyEnvironment -Source "PTU" -Destination "LIVE"
                        Write-Host
                        pause    
                    }
                    '4' {
                        copyEnvironment -Source "PTU" -Destination "EPTU"
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
                        deleteEAC -Environment "EPTU"
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteUser -Environment "EPTU"
                        Write-Host
                        pause    
                    }
                    '3' {
                        copyEnvironment -Source "EPTU" -Destination "LIVE"
                        Write-Host
                        pause    
                    }
                    '4' {
                        copyEnvironment -Source "EPTU" -Destination "PTU"
                        Write-Host
                        pause    
                    }
                }
            }
            until ($selection3 -eq 'b')
        } '4' {
            do
            {
                Show-TECH-PREVIEW-Menu
                $selection4 = Read-Host "Please make a selection"
                switch ($selection4)
                {
                    '1' {
                        deleteEAC -Environment "TECH-PREVIEW"
                        Write-Host
                        pause    
                    }
                    '2' {
                        deleteUser -Environment "TECH-PREVIEW"
                        Write-Host
                        pause    
                    }
                    '3' {
                        copyEnvironment -Source "TECH-PREVIEW" -Destination "LIVE"
                        Write-Host
                        pause    
                    }
                }
            }
            until ($selection4 -eq 'b')
        } '5' {
            do
            {
                Show-General-Menu
                $selection5 = Read-Host "Please make a selection"
                switch ($selection5)
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
            until ($selection5 -eq 'b')
        }
    }
}
until ($selection -eq 'q')
Clear-Host
