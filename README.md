# Star Citizen Troubleshooting Script

Welcome to my PowerShell script for common troubleshooting steps with Star Citizen. This initially started life as a clean shader script, and was updated over the years to accomodate for the new shader location starting with Alpha 3.17, and adding additional features such as the ability to delete EasyAntiCheat, the USER folder, the old logs and crashdumps left behind from previous builds, and the latest feature - to prepare the PTU and EPTU environments for the next upcoming release by copying the current LIVE build across, whilst preserving the USER and ScreenShots folder if they already exist.

## How to Use

Download the sc-troubleshooting.ps1 script from GitHub and copy it to any appropriate folder (for example, *C:\Program Files\Roberts Space Industries\StarCitizen*). Simply run the script in PowerShell, and it'll initially ask you for the path where you installed Star Citizen, and then present you with the following menu:

![screenshot](https://github.com/DeusMaximus/sc-troubleshooting/assets/10080364/2c3a12cf-caad-4df8-a245-3fef2bee4d30)

To create a shortcut to this file, simply right click on the desktop and select "New > Shortcut" and paste the following single line into the Location prompt (Assuming you saved the script to *C:\Program Files\Roberts Space Industries\StarCitizen*):

``C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noprofile -executionpolicy bypass -file "C:\Program Files\Roberts Space Industries\StarCitizen\sc-troubleshooting.ps1"``

## Features

### Shader deletion

Deletes all shaders from the local AppData folder, in addition to the old pre-3.17 shaders that resided in the USER folder if they're still around. This is helpful for trying to resolve any weird graphical glitches, especially with new Star Citizen builds.

### Debug logs and log backup deletion

Deletes old log files from the DebugLogs and logbackups location, but keeps the current game.log file intact. This was added when a specific patch had a bug that caused old log files to balloon out of control.

### Crash dump deletion

Whenever the game crashes, crash dumps are stored in the local AppData folder for the crash handler to upload back to CIG. This option allows you to clean up any residual files left over from that process.

### EasyAntiCheat deletion

Deleting the EasyAntiCheat folder is an additional troubleshooting step when the game fails to load. You'll need to re-verify files again in order to redownload and reinstall EasyAntiCheat, before logging into Star Citizen.

### USER folder deletion (both LIVE and PTU/EPTU options)

The USER folder is where all your graphic settings, control settings and keybinds live. This also used to be the place where shaders were compiled, and deleting this folder used to be a common troubleshooting step. Nowadays, this isn't as necessary and is generally not recommended as this option nuke all your control settings and custom keybinds. However, it can be a helpful step to start fresh - especially when it comes to the PTU/EPTU environments.

### Public Test Universe / Experimental Public Test Universe preparation

The PTU and EPTU environments are testing environments for the next live release of Star Citizen. These options allow you to erase the contents of the PTU and EPTU folders, and copy the relevant contents of the LIVE folder across in preparation of a new patch - this gives you a head start and allows you to patch what's currently there, as opposed to redownloading 100GB or more of data all over again just for the PTU/EPTU. After copying the contents across, simply Verify the files in the RSI launcher as opposed to downloading or updating.

## Quick Glossary

- **Shaders** - These are files compiled by Star Citizen, and is cached on your computer to save having to recompile them every time. It's why the game runs like crap on a new patch or fresh install for the first 15 to 30 minutes or if you visit an area you haven't been to before, but runs much smoother each time afterwards. Originally located in the USER folder, these now reside in your local AppData folder.
- **AppData** - This is a folder used by Windows to store application data. In the case of Star Citizen, we use the *local* AppData folder, which means it's stored locally on your computer and is specific for each individual Windows user account. The RSI launcher's login data, Star Citizen's shader cache, and crash dump files generally live here.
- **LIVE, PTU and EPTU** - These are the names for the three game enviroments for Star Citizen. LIVE is the currently released version of Star Citizen, PTU is the Public Test Universe environment for the next release of Star Citizen, and EPTU stands for Experimental Public Test Universe, which is used for more experimental features and testing. The EPTU is more commonly associated with the Evocati testers - the initial external (but still under NDA) testing group, although EPTU has been opened up to non-Evocati players in the past.
- **USER** - The USER folder is where all your graphic settings, control settings and keybinds live. This also used to be the place where shaders were compiled, and deleting this folder used to be a common troubleshooting step. Nowadays, this isn't as necessary and is generally not recommended as this option nuke all your control settings and custom keybinds. However, it can be a helpful step to start fresh - especially when it comes to the PTU/EPTU environments.
- **EasyAntiCheat** - EAC is an anti-cheat system developed by Epic, and is used in Star Citizen. Some issues in the past, and some currently ongoing update issues as well, can be resolved by deleting the folder that EAC lives in for Star Citizen, and using the launcher to redownload and reinstall it. However, the game won't function without this folder, so if you choose to delete the EAC folder, you *must* re-verify files again in the launcher.
