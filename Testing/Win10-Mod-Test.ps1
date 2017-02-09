##########
# Win10 Initial Setup Script
# 
# Original Script Info
# Author: Disassembler <disassembler@dasm.cz>
# Website: https://github.com/Disassembler0/Win10-Initial-Setup-Script/
# Version: 2.0, 2017-01-08
#
# Modded Script Info
# Author: Madbomb122
# Website: https://github.com/madbomb122/Win10Script
# Version: 3.6-Mod, 02-??-2017
# Release Type: Testing
##########
<#
    Copyright (c) 2017 Disassembler <disassembler@dasm.cz> -Original Version of Script
    Copyright (c) 2017 Madbomb122 -Modded Version of Script
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

<#
----------------------------------------------------------------------------
.DESCRIPTION
    Makes it easier to setup an existing or new install with moded setting

.BASIC USAGE
	Edit this file and change what settings you want changed
	
.ADVANCED USAGE
  To run the script with the Items in the script back to the Default 
  for windows run the script with one of the 2 switches bellow:
    -Set WD
    -Set WindowsDefault 

Example: Win10-Mod.ps1 -Set WD
Example: Win10-Mod.ps1 -Set WindowsDefault
------
  To run the script with imported Settings run the script with:	
	-Set Filename

Example: Win10-Mod.ps1 -Set File.txt
Example: Win10-Mod.ps1 -Set Example

Note: File has to be in the proper format or settings wont be imported
------
  To run the script with the settings i use:	
	-Set Set1

Example: Win10-Mod.ps1 -Set Set1
----------------------------------------------------------------------------
#>

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!             DO NOT TOUCH NEXT LINE             !!!!!!!!!
<# !!!!!!!!!#> Param([alias("Set")] [string] $SettingImp) ##!!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# --------------------------------------------------------------------------

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!               SAFE TO EDIT VALUES              !!!!!!!!!
## !!!!!!!!!                  -- START --                   !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Edit values (Option) to your preferance
# Change to an Option not listed will Skip the Function/Setting

# Note: If you're not sure what something does dont change it or do a web search 

# Can ONLY create 1 per 24 hours with this script (Will give error if it tries)
$CreateRestorePoint = 0    #0-Skip, 1-Create --(Restore point before script runs)

# Skips Term of Use
$Term_of_Use = 1           #1-See, Anything else = Accepts Term of Use

# Output Display
$Verbros = 1               #0-Dont Show output, 1-Show output
$ShowColor = 1             #0-Dont Show output Color, 1-Show output Colors

# Restart when done? (I recommend restarting when done)
$Restart = 1               #0-Dont Restart, 1-Restart

# Windows Default for ALL Settings 
$WinDefault = 2            #1-Yes*, 2-No 
# IF 1 is set then Everything Other than the following will use the Default Win Settings
# ALL Values Above this one, All Metro Apps and $OneDriveInstall  (These will use what you set)

# Privacy Settings
# Function  = Option       #Choices (* Indicates Windows Default)
$Telemetry = 0             #0-Skip, 1-Enable*, 2-Disable
$WiFiSense = 0             #0-Skip, 1-Enable*, 2-Disable
$SmartScreen = 0           #0-Skip, 1-Enable*, 2-Disable --(phishing and malware filter for soe MS Apps/Prog)
$LocationTracking = 0      #0-Skip, 1-Enable*, 2-Disable
$Feedback = 0              #0-Skip, 1-Enable*, 2-Disable
$AdvertisingID = 0         #0-Skip, 1-Enable*, 2-Disable     
$Cortana = 0               #0-Skip, 1-Enable*, 2-Disable
$CortanaSearch = 0         #0-Skip, 1-Enable*, 2-Disable --(If you disable Cortana you can still search with this)
$ErrorReporting = 0        #0-Skip, 1-Enable*, 2-Disable
$AutoLoggerFile = 0        #0-Skip, 1-Enable*, 2-Disable
$DiagTrack = 0             #0-Skip, 1-Enable*, 2-Disable
$WAPPush = 0               #0-Skip, 1-Enable*, 2-Disable --(type of text message that contains a direct link to a particular Web page)
$AppAutoDownload = 0       #0-Skip, 1-Enable*, 2-Disable

# Windows Update
# Function  = Option       #Choices (* Indicates Windows Default)
$CheckForWinUpdate = 0     #0-Skip, 1-Enable*, 2-Disable
$WinUpdateType = 0         #0-Skip, 1-Notify, 2-Auto DL, 3-Auto DL+Install*, 4-Local admin chose --(May not work with Home version)
$WinUpdateDownload = 0     #0-Skip, 1-P2P*, 2-Local Only, 3-Disable
$UpdateMSRT = 0            #0-Skip, 1-Enable*, 2-Disable --(Malware Software Removal Tool)
$UpdateDriver = 0          #0-Skip, 1-Enable*, 2-Disable --(Offering of drivers through Windows Update)
$RestartOnUpdate = 0       #0-Skip, 1-Enable*, 2-Disable

# Service Tweaks
# Function  = Option       #Choices (* Indicates Windows Default)
$UAC = 0                   #0-Skip, 1-Lower, 2-Normal*, 3-Higher
$SharingMappedDrives = 0   #0-Skip, 1-Enable, 2-Disable* --(Sharing mapped drives between users)
$AdminShares = 0           #0-Skip, 1-Enable*, 2-Disable --(Default admin shares for each drive)
$Firewall = 0              #0-Skip, 1-Enable*, 2-Disable
$WinDefender = 0           #0-Skip, 1-Enable*, 2-Disable
$HomeGroups = 0            #0-Skip, 1-Enable*, 2-Disable
$RemoteAssistance = 0      #0-Skip, 1-Enable*, 2-Disable
$RemoteDesktop = 0         #0-Skip, 1-Enable, 2-Disable* --(Remote Desktop w/o Network Level Authentication)
 
#Context Menu Items
# Function  = Option       #Choices (* Indicates Windows Default)
$CastToDevice = 0          #0-Skip, 1-Enable*, 2-Disable
$PreviousVersions = 0      #0-Skip, 1-Enable*, 2-Disable
$IncludeinLibrary = 0      #0-Skip, 1-Enable*, 2-Disable
$PinTo = 0                 #0-Skip, 1-Enable*, 2-Disable
$ShareWith = 0             #0-Skip, 1-Enable*, 2-Disable
$SendTo = 0                #0-Skip, 1-Enable*, 2-Disable

#Task Bar Items
# Function  = Option       #Choices (* Indicates Windows Default)
$BatteryUIBar = 0          #0-Skip, 1-New*, 2-Classic --(Classic is Win 7 version)
$ClockUIBar = 0            #0-Skip, 1-New*, 2-Classic --(Classic is Win 7 version)
$VolumeControlBar = 0      #0-Skip, 1-New(Horizontal)*, 2-Classic(Vertical) --(Classic is Win 7 version)
$TaskbarSearchBox = 0      #0-Skip, 1-Show*, 2-Hide
$TaskViewButton = 0        #0-Skip, 1-Show*, 2-Hide
$TaskbarIconSize = 0       #0-Skip, 1-Normal*, 2-Smaller
$TaskbarGrouping = 0       #0-Skip, 1-Never, 2-Always*, 3-When Needed
$TrayIcons = 0             #0-Skip, 1-Auto*, 2-Always Show     
$SecondsInClock = 0        #0-Skip, 1-Show, 2-Hide*
$LastActiveClick = 0       #0-Skip, 1-Enable, 2-Disable* --(Makes Taskbar Buttons Open the Last Active Window)
$TaskBarOnMultiDisplay = 0 #0-Skip, 1-Enable*, 2-Disable
$TaskbarButtOnDisplay = 0  #0-Skip, 1-All, 2-where window is open, 3-Main and where window is open

#Star Menu Items
# Function  = Option       #Choices (* Indicates Windows Default)
$StartMenuWebSearch = 0    #0-Skip, 1-Enable*, 2-Disable
$StartSuggestions = 0      #0-Skip, 1-Enable*, 2-Disable --(The Suggested Apps in Start Menu)
$MostUsedAppStartMenu = 0  #0-Skip, 1-Show*, 2-Hide
$RecentItemsFrequent = 0   #0-Skip, 1-Enable*, 2-Disable --(In Start Menu)

#Explorer Items
# Function  = Option       #Choices (* Indicates Windows Default)
$Autoplay = 0              #0-Skip, 1-Enable*, 2-Disable
$Autorun = 0               #0-Skip, 1-Enable*, 2-Disable
$PidInTitleBar = 0         #0-Skip, 1-Show, 2-Hide* --(PID = Processor ID)
$AeroSnap = 0              #0-Skip, 1-Enable*, 2-Disable --(Allows you to quickly resize the window you’re currently using)
$AeroShake = 0             #0-Skip, 1-Enable*, 2-Disable
$KnownExtensions = 0       #0-Skip, 1-Show, 2-Hide*
$HiddenFiles = 0           #0-Skip, 1-Show, 2-Hide*
$SystemFiles = 0           #0-Skip, 1-Show, 2-Hide*
$ThisPCOnDesktop = 0       #0-Skip, 1-Show, 2-Hide*
$ExplorerOpenLoc = 0       #0-Skip, 1-Quick Access*, 2-ThisPC --(What location it opened when you open an explorer window)
$RecentFileQikAcc = 0      #0-Skip, 1-Show/Add*, 2-Hide, 3-Remove --(Recent Files in Quick Access)
$FrequentFoldersQikAcc = 0 #0-Skip, 1-Show*, 2-Hide --(Frequent Folders in Quick Access)
$WinContentWhileDrag = 0   #0-Skip, 1-Show*, 2-Hide

#'This PC' items
# Function  = Option       #Choices (* Indicates Windows Default)
$DesktopIconInThisPC = 0   #0-Skip, 1-Show*, 2-Hide
$DocumentsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$DownloadsIconInThisPC = 0 #0-Skip, 1-Show*, 2-Hide
$MusicIconInThisPC = 0     #0-Skip, 1-Show*, 2-Hide
$PicturesIconInThisPC = 0  #0-Skip, 1-Show*, 2-Hide
$VideosIconInThisPC = 0    #0-Skip, 1-Show*, 2-Hide

# Photo Viewer Settings
# Function  = Option       #Choices (* Indicates Windows Default)
$PVFileAssociation = 0     #0-Skip, 1-Enable, 2-Disable*
$PVOpenWithMenu = 0        #0-Skip, 1-Enable, 2-Disable*

#Lock Screen
# Function  = Option       #Choices (* Indicates Windows Default)
$LockScreen = 0            #0-Skip, 1-Enable*, 2-Disable (Pre-Anniversary Update)
$LockScreenAlt = 0         #0-Skip, 1-Enable*, 2-Disable (Anniversary Update workaround) 
$PowerMenuLockScreen = 0   #0-Skip, 1-Show*, 2-Hide
$CameraOnLockScreen = 0    #0-Skip, 1-Enable*, 2-Disable
$HibernatePower = 1        #0-Skip, 1-Enable, 2-Disable --(Hibernate Power Option)
$SleepPower = 1            #0-Skip, 1-Enable*, 2-Disable --(Sleep Power Option)

#Misc items
# Function  = Option       #Choices (* Indicates Windows Default)
$ActionCenter = 0          #0-Skip, 1-Enable*, 2-Disable
$StickyKeyPrompt = 0       #0-Skip, 1-Enable*, 2-Disable
$NumblockOnStart = 0       #0-Skip, 1-Enable, 2-Disable*
$F8BootMenu = 0            #0-Skip, 1-Enable, 2-Disable*
$RemoteUACAcctToken = 0    #0-Skip, 1-Enable, 2-Disable*

# Remove unwanted applications
# Function  = Option       #Choices (* Indicates Windows Default)
$OneDrive = 0              #0-Skip, 1-Enable*, 2-Disable
$OneDriveInstall = 0       #0-Skip, 1-Installed*, 2-Uninstall
$XboxDVR = 0               #0-Skip, 1-Enable*, 2-Disable
$MediaPlayer = 0           #0-Skip, 1-Installed*, 2-Uninstall
$WorkFolders = 0           #0-Skip, 1-Installed*, 2-Uninstall
$LinuxSubsystem = 0        #0-Skip, 1-Installed, 2-Uninstall* (Anniversary Update)

#Disabled Items (Till Fixed)
#$MoreColorsTitle = 0       #0-Skip, 1-Enable, 2-Disable* --(Adds more Colors to pick from for the Title Colors)


# Custom List of App to Install, Hide or Uninstall
# I dunno if you can Install random apps with this script
# Cant Import these ATM
$APPS_AppsInstall = @()    # Apps to Install
$APPS_AppsHide = @()       # Apps to Hide
$APPS_AppsUninstall = @()  # Apps to Uninstall
#$APPS_Example = @('Somecompany.Appname1','TerribleCompany.Appname2','SomeCrap.Appname3')
# To get list of Packages Installed
# DISM /Online /Get-ProvisionedAppxPackages | Select-string Packagename

<# 
App Uninstall will remove them to reinstall you can
1. Install some from Windows Store
2. Restore the files using installation medium as follows
New-Item C:\Mnt -Type Directory | Out-Null
dism /Mount-Image /ImageFile:D:\sources\install.wim /index:1 /ReadOnly /MountDir:C:\Mnt
robocopy /S /SEC /R:0 "C:\Mnt\Program Files\WindowsApps" "C:\Program Files\WindowsApps"
dism /Unmount-Image /Discard /MountDir:C:\Mnt
Remove-Item -Path C:\Mnt -Recurse
#>

# Metro Apps
# By Default Most of these are installed
# Function  = Option       # 0-Skip, 1-Unhide, 2- Hide, 3-Uninstall (!!Read Note Above)
$APP_3DBuilder = 0         # '3DBuilder' app
$APP_AdvertisingXaml = 0   ## Removal may cause problem with some apps
$APP_Appconnector = 0      ## Not sure about this one
$APP_Asphalt8Airborne = 0  # 'Asphalt 8' game
$APP_BingFinance = 0       # 'Money' app - Financial news
$APP_BingFoodAndDrink = 0  # 'Food and Drink' app
$APP_BingHealthFitness = 0 # 'Health and Fitness' app
$APP_BingNews = 0          # 'Generic news' app
$APP_BingSports = 0        # 'Sports' app - Sports news
$APP_BingTranslator = 0    # 'Translator' app - Bing Translate
$APP_BingTravel = 0        # 'Travel' app
$APP_BingWeather = 0       # 'Weather' app
$APP_CandyCrushSoda = 0    # 'Candy Crush' game 
$APP_CommsPhone = 0        # 'Phone' app
$APP_Communications = 0    # 'Calendar and Mail' app
$APP_ConnectivityStore = 0     
$APP_Facebook = 0          # 'Facebook' app
$APP_FarmVille = 0         # 'Farm Ville' game
$APP_FreshPaint = 0        # 'Canvas' app
$APP_Getstarted = 0        # 'Get Started' link
$APP_Messaging = 0         # 'Messaging' app
$APP_MicrosoftJackpot = 0  # 'Jackpot' app
$APP_MicrosoftJigsaw = 0   # 'Jigsaw' game       
$APP_MicrosoftMahjong = 0  # 'Mahjong' game
$APP_MicrosoftOffHub = 0   # 'Office Hub' app 
$APP_MicrosoftSudoku = 0   # 'Sudoku' game 
$APP_MinecraftUWP = 0      # 'Minecraft' game    
$APP_MovieMoments = 0        
$APP_Netflix = 0           # 'Netflix' app
$APP_OfficeOneNote = 0     # 'Onenote' app
$APP_OfficeSway = 0        # 'Sway' app
$APP_OneConnect=0
$APP_People = 0            # 'People' app
$APP_Photos = 0            # Photos app
$APP_SkypeApp = 0          # 'Get Skype' link
$APP_SkypeWiFi = 0         
$APP_SolitaireCollect = 0  # Solitaire collection
$APP_SoundRecorder = 0     # 'Sound Recorder' app
$APP_StickyNotes = 0       # 'Sticky Notes' app 
$APP_StudiosWordament = 0  # 'Wordament' game
$APP_Taptiles = 0          
$APP_Twitter = 0           # 'Twitter' app
$APP_WindowsAlarms = 0     # 'Alarms and Clock' app
$APP_WindowsCalculator = 0 # 'Calculator' app
$APP_WindowsCamera = 0     # 'Camera' app
$APP_WindowsFeedbak = 0    # 'Feedback' functionality
$APP_WindowsFeedbakHub = 0 # 'Feedback' functionality
$APP_WindowsMaps = 0       # 'Maps' app
$APP_WindowsPhone = 0      # 'Phone Companion' app
$APP_WindowsStore = 0      # Windows Store
$APP_XboxApp = 0           # 'Xbox' app 
$APP_ZuneMusic = 0         # 'Groove Music' app
$APP_ZuneVideo = 0         # 'Groove Music' app


## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!               SAFE TO EDIT VALUES              !!!!!!!!!
## !!!!!!!!!                   -- END --                    !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# --------------------------------------------------------------------------

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## !!!!!!!!!                     CAUTION                    !!!!!!!!!
## !!!!!!!!!          DO NOT EDIT PAST THIS POINT           !!!!!!!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


##########
# Needed Variable -Start
##########

$AppsList = @(
    'Microsoft.3DBuilder',
    'Microsoft.Advertising.Xaml',
    'Microsoft.Appconnector',
    'GAMELOFTSA.Asphalt8Airborne',
    'Microsoft.BingFinance',
    'Microsoft.BingFoodAndDrink',
    'Microsoft.BingHealthAndFitness',
    'Microsoft.BingNews',
    'Microsoft.BingSports',
    'Microsoft.BingTranslator',
    'Microsoft.BingTravel',
    'Microsoft.BingWeather',
    'king.com.CandyCrushSodaSaga',
    'Microsoft.CommsPhone',
    'Microsoft.windowscommunicationsapps',
    'Microsoft.ConnectivityStore',
    'Facebook.Facebook',
    'D52A8D61.FarmVille2CountryEscape',
    'Microsoft.FreshPaint',
    'Microsoft.Getstarted',
    'Microsoft.Messaging',
    'Microsoft.MicrosoftJackpot',
    'Microsoft.MicrosoftJigsaw',          
    'MicrosoftMahjong',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.MicrosoftSudoku',
    'Microsoft.MinecraftUWP',   
    'Microsoft.MovieMoments',
    '4DF9E0F8.Netflix',
    'Microsoft.Office.OneNote',
    'Microsoft.Office.Sway',
    'Microsoft.OneConnect',
    'Microsoft.People',
    'Microsoft.Windows.Photos',
    'Microsoft.SkypeApp',
    'Microsoft.SkypeWiFi',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.WindowsSoundRecorder',
    'Microsoft.MicrosoftStickyNotes',
    'Microsoft.Studios.Wordament',
    'Microsoft.Taptiles',
    '9E2F88E3.Twitter',
    'Microsoft.WindowsAlarms',
    'Microsoft.WindowsCalculator',
    'Microsoft.WindowsCamera',
    'Microsoft.WindowsFeedback',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.WindowsMaps',
    'Microsoft.WindowsPhone',
    'Microsoft.WindowsStore',
    'Microsoft.XboxApp',
    'Microsoft.ZuneMusic',
    'Microsoft.ZuneVideo'
)

# predefined Color Array
$colors = @(
     "black",        #0
     "blue",         #1
     "cyan",         #2
     "darkblue",     #3
     "darkcyan",     #4
     "darkgray",     #5
     "darkgreen",    #6
     "darkmagenta",  #7
     "darkred",      #8
     "darkyellow",   #9
     "gray",         #10
     "green",        #11
     "magenta",      #12
     "red",          #13
     "white",        #14
     "yellow"        #15
)

$CustomSet = 0

##########
# Needed Variable -End
##########

##########
# Script Start -Start
##########

# Ask for elevated permissions if required
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
     Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
     Exit
}

If ($SettingImp -ne $null -and $SettingImp){
     If (Test-Path $SettingImp -PathType Leaf){
         # // File exists
         Get-Content $SettingImp | Foreach-Object{
             $var = $_.Split("=")
             Set-Variable -Name $var[0] -Value $var[1]
         }
	} ElseIf ($SettingImp -eq "WD" -or $SettingImp -eq "WindowsDefault"){
	     $WinDefault = 1
    } ElseIf ($SettingImp -eq "Set1"){
	     $CustomSet = 1
    }
} 

# Asks for input before continuing
# Doesnt work in PowerShell ISE
If ($Term_of_Use -eq 1){
     Write-Host "WARNING!!" -ForegroundColor Red -BackgroundColor Black
     Write-Host "This version is currently being tested and May have problems." -ForegroundColor Yellow -BackgroundColor Black 
     Write-Host ""
     Write-Host "This program comes with ABSOLUTELY NO WARRANTY." -ForegroundColor Black -BackgroundColor White
     Write-Host "This is free software, and you are welcome to" -ForegroundColor Black -BackgroundColor White
     Write-Host "redistribute it under certain conditions." -ForegroundColor Black -BackgroundColor White
     Write-Host ""
     Write-Host "Read License file for full Terms." -ForegroundColor Black -BackgroundColor White
     Write-Host ""
     Write-Host "Do you Accept the Term of Use? (y/n)" -ForegroundColor White -BackgroundColor Black	
     $KeyPress= $HOST.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
     $KeyPress=$KeyPress.Character	 
     $HOST.UI.RawUI.Flushinputbuffer()
}

If($KeyPress -eq 'y' -or $Term_of_Use -ne 1) {
     Write-Host "Running Script" -ForegroundColor Green -BackgroundColor Black 
	 Write-Host ""
} ElseIf($KeyPress -eq 'n'){
     Write-Host "Exiting Script, Goodbye" -ForegroundColor Red -BackgroundColor Black 
     exit
} Else{
     Write-Host "Invalid Input, Goodbye" -ForegroundColor Red -BackgroundColor Black 
     exit	 
}

# Define HKCR
If (!(Test-Path "HKCR:")) {
     New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

# Define HKU
If (!(Test-Path "HKU:")) {
     New-PSDrive -Name HKU -PSProvider Registry -Root HKEY_USERS | Out-Null
}

# Check OS bit type
If ([Environment]::Is32BitProcess -eq $true){
     $OSType=32
} ElseIf ([Environment]::Is64BitProcess -eq $true){
     $OSType=64
} Else {
     $OSType=0
}

# Sorts the apps to Install, Hide or Uninstall
$APPProcess = Get-Variable -Name "APP_*" -ValueOnly

$i=0
ForEach ($AppV in $APPProcess) {
     If($AppV -eq 1){
         $APPS_AppsInstall+=$AppsList[$i]
     } Elseif($AppV -eq 2){
         $APPS_AppsHide+=$AppsList[$i]
     } Elseif($AppV -eq 3){
         $APPS_AppsUninstall+=$AppsList[$i]
     }
    $i++
}

# Function to Display or Not Display OUTPUT
Function DisplayOut([String]$TxtToDisplay,[int]$TxtColor,[int]$BGColor){
   If($Verbros -eq 1){
     If($TxtColor -le 15 -and $ShowColor -eq 1){
         Write-Host $TxtToDisplay -ForegroundColor $colors[$TxtColor] -BackgroundColor $colors[$BGColor]
	 } Else {
         Write-Host $TxtToDisplay
	 }
   } 
}

# Creates Restore Points
If ($CreateRestorePoint -eq 1) {
     DisplayOut "Creating System Restore Point Named -Win10 Initial Setup Script..." 15 1
     Checkpoint-Computer -Description "Win10 Initial Setup Script" | Out-Null
}


##########
# Script Start -End
##########

##########
# Pre-Made Settings -Start
##########

# Windows Default Setting
If($WinDefault -eq 1){
     $WinUpdateType = 3
     $RecentFileQikAcc = 1
     $FrequentFoldersQikAcc = 1
     $MostUsedAppStartMenu = 1
     $PowerMenuLockScreen = 1
     $WinContentWhileDrag = 1
     $CheckForWinUpdate = 1
     $TaskBarOnMultiDisplay = 1
     $TaskbarButtOnDisplay = 0
     $Telemetry = 1
     $WiFiSense = 1
     $SmartScreen = 1
     $StartMenuWebSearch = 1
     $StartSuggestions = 1
     $AppAutoDownload = 1
     $LocationTracking = 1
     $Feedback = 1
     $AdvertisingID = 1
     $Cortana = 1
     $CortanaSearch = 1
     $ErrorReporting = 1
     $WinUpdateDownload = 1
     $AutoLoggerFile = 1
     $DiagTrack = 1
     $WAPPush = 1
     $UAC = 2
     $SharingMappedDrives = 2
     $AdminShares = 1
     $Firewall = 1
     $WinDefender = 1
     $HomeGroups = 1
     $RemoteAssistance = 1
     $RemoteDesktop = 2
     $UpdateMSRT = 1
     $UpdateDriver = 1
     $RestartOnUpdate = 1
     $CastToDevice = 1 
     $PreviousVersions = 1
     $IncludeinLibrary = 1
     $PinTo = 1
     $ShareWith = 1
     $SendTo = 1
     $BatteryUIBar = 1
     $ClockUIBar = 1
     $VolumeControlBar = 1
     $TaskbarSearchBox = 1
     $TaskViewButton = 1
     $TaskbarIconSize = 1
     $TaskbarGrouping = 2
     $TrayIcons = 1
     $SecondsInClock = 2
     $LastActiveClick = 2
     $MoreColorsTitle = 2
     $PidInTitleBar = 2
     $AeroSnap = 1
     $AeroShake = 1
     $KnownExtensions = 2
     $HiddenFiles = 2
     $SystemFiles = 2
     $ThisPCOnDesktop = 2
     $ExplorerOpenLoc = 1
     $RecentItemsFrequent = 1
     $DesktopIconInThisPC = 1
     $DocumentsIconInThisPC = 1
     $DownloadsIconInThisPC = 1
     $MusicIconInThisPC = 1
     $PicturesIconInThisPC = 1
     $VideosIconInThisPC = 1
     $PVFileAssociation = 2
     $PVOpenWithMenu = 2
     $CameraOnLockScreen = 1
     $LockScreen = 1
     $LockScreenAlt = 1
     $ActionCenter = 1
     $Autoplay = 1
     $Autorun = 1
     $StickyKeyPrompt = 1
     $NumblockOnStart = 2
     $F8BootMenu = 1
     $OneDrive = 1
     $XboxDVR = 1
     $MediaPlayer = 1
     $WorkFolders = 1
     $LinuxSubsystem = 2
     $RemoteUACAcctToken = 2
}

# My Custom Setting
If($CustomSet -eq 1){
     $WinUpdateType = 1
     $RecentFileQikAcc = 2
     $FrequentFoldersQikAcc = 2
     $MostUsedAppStartMenu = 2
     $PowerMenuLockScreen = 1
     $HibernatePower = 0
     $SleepPower = 2
     $WinContentWhileDrag = 1
     $CheckForWinUpdate = 2
     $TaskBarOnMultiDisplay = 2
     $TaskbarButtOnDisplay = 1
     $Telemetry = 2
     $WiFiSense = 2
     $SmartScreen = 0
     $StartMenuWebSearch = 2
     $StartSuggestions = 2
     $AppAutoDownload = 2
     $LocationTracking = 2
     $Feedback = 2
     $AdvertisingID = 2
     $Cortana = 2
     $CortanaSearch = 1
     $ErrorReporting = 1
     $WinUpdateDownload = 2
     $AutoLoggerFile = 1
     $DiagTrack = 1
     $WAPPush = 2
     $UAC = 2
     $SharingMappedDrives = 2
     $AdminShares = 1
     $Firewall = 1
     $WinDefender = 2
     $HomeGroups = 2
     $RemoteAssistance = 2
     $RemoteDesktop = 2
     $UpdateMSRT = 2
     $UpdateDriver = 1
     $RestartOnUpdate = 2
     $CastToDevice = 2
     $PreviousVersions = 2
     $IncludeinLibrary = 2
     $PinTo = 2
     $ShareWith = 2
     $SendTo = 2
     $BatteryUIBar = 1
     $ClockUIBar = 1
     $VolumeControlBar = 2
     $TaskbarSearchBox = 2
     $TaskViewButton = 2
     $TaskbarIconSize = 1
     $TaskbarGrouping = 3
     $TrayIcons = 1
     $SecondsInClock = 2
     $LastActiveClick = 1
     $MoreColorsTitle = 1
     $PidInTitleBar = 1
     $AeroSnap = 2
     $AeroShake = 2
     $KnownExtensions = 1
     $HiddenFiles = 1
     $SystemFiles = 1
     $ThisPCOnDesktop = 1
     $ExplorerOpenLoc = 1
     $RecentItemsFrequent = 2
     $DesktopIconInThisPC = 2
     $DocumentsIconInThisPC = 2
     $DownloadsIconInThisPC = 2
     $MusicIconInThisPC = 2
     $PicturesIconInThisPC = 2
     $VideosIconInThisPC = 2
     $PVFileAssociation = 1
     $PVOpenWithMenu = 1
     $CameraOnLockScreen = 2
     $LockScreen = 1
     $LockScreenAlt = 1
     $ActionCenter = 2
     $Autoplay = 2
     $Autorun = 2
     $StickyKeyPrompt = 2
     $NumblockOnStart = 2
     $F8BootMenu = 1
     $OneDrive = 2
     $XboxDVR = 2
     $MediaPlayer = 1
     $WorkFolders = 2
     $LinuxSubsystem = 2
     $RemoteUACAcctToken = 1
     $APP_3DBuilder=3
     $APP_AdvertisingXaml=0
     $APP_Appconnector=0
     $APP_Asphalt8Airborne=3
     $APP_BingFinance=3
     $APP_BingFoodAndDrink=3
     $APP_BingHealthFitness=3
     $APP_BingNews=3
     $APP_BingSports=3
     $APP_BingTranslator=3
     $APP_BingTravel=3
     $APP_BingWeather=0
     $APP_CandyCrushSoda=3
     $APP_CommsPhone=3
     $APP_Communications=3
     $APP_ConnectivityStore=0
     $APP_Facebook=3
     $APP_FarmVille=3
     $APP_FreshPaint=0
     $APP_Getstarted=3
     $APP_Messaging=3
     $APP_MicrosoftJackpot=3
     $APP_MicrosoftJigsaw=3
     $APP_MicrosoftMahjong=3
     $APP_MicrosoftOfficeHub=3       
     $APP_MicrosoftSudoku=0
     $APP_MinecraftUWP=3
     $APP_MovieMoments=3
     $APP_Netflix=0
     $APP_OfficeOneNote=3
     $APP_OfficeSway=3
     $APP_OneConnect=3
     $APP_People=3
     $APP_Photos=0
     $APP_SkypeApp=3
     $APP_SkypeWiFi=3
     $APP_SolitaireCollection=3
     $APP_SoundRecorder=3
     $APP_StickyNotes=0
     $APP_StudiosWordament=3
     $APP_Taptiles=3
     $APP_Twitter=3
     $APP_WindowsAlarms=0
     $APP_WindowsCalculator=0
     $APP_WindowsCamera=3
     $APP_WindowsFeedback=3
     $APP_WindowsFeedbackHub=3
     $APP_WindowsMaps=0
     $APP_WindowsPhone=3
     $APP_WindowsStore=0
     $APP_XboxApp=0
     $APP_ZuneMusic=3
     $APP_ZuneVideo=3
}

##########
# Pre-Made Settings -End
##########

##########
# Privacy Settings -Start
##########

DisplayOut ""
DisplayOut "------------------------" 14 0
DisplayOut "-   Privacy Settings   -" 14 0
DisplayOut "------------------------" 14 0
DisplayOut ""

# Telemetry
If ($Telemetry -eq 1) {
     DisplayOut "Enabling Telemetry..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 3
} ElseIf ($Telemetry -eq 2) {
     DisplayOut "Disabling Telemetry..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0

	 #check these paths for telemetry
<#
"hkey_local_machine\software\microsoft\wcmsvc\wifinetworkmanager"
"hkey_local_machine\software\microsoft\windows\currentversion\windowsupdate\auto update"
"hkey_local_machine\software\microsoft\windows defender\spynet"
"hkey_local_machine\software\policies\microsoft\windows\gwx"
"hkey_local_machine\software\policies\microsoft\windows\skydrive"
#>
}

# Wi-Fi Sense
If ($WiFiSense -eq 1) {
     DisplayOut "Enabling Wi-Fi Sense..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 1
} ElseIf ($WiFiSense -eq 2) {
     DisplayOut "Disabling Wi-Fi Sense..." 12 0
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
         New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
}

# SmartScreen Filter
If ($SmartScreen -eq 1) {
     DisplayOut "Enabling SmartScreen Filter..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "RequireAdmin"
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -ErrorAction SilentlyContinue
} ElseIf ($SmartScreen -eq 2) {
     DisplayOut "Disabling SmartScreen Filter..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off"
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 0
}

# Location Tracking
If ($LocationTracking -eq 1) {
     DisplayOut "Enabling Location Tracking..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 1
} ElseIf ($LocationTracking -eq 2) {
     DisplayOut "Disabling Location Tracking..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
}

# Disable Feedback
If ($LocationTracking -eq 1) {
     DisplayOut "Enabling Feedback..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -ErrorAction SilentlyContinue
} ElseIf ($LocationTracking -eq 2) {
     DisplayOut "Disabling Feedback..." 12 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
}

# Disable Advertising ID
If ($AdvertisingID -eq 1) {
     DisplayOut "Enabling Advertising ID..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -ErrorAction SilentlyContinue
} ElseIf ($AdvertisingID -eq 2) {
     DisplayOut "Disabling Advertising ID..." 12 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value 0
}

# Cortana
If ($Cortana -eq 1) {
     DisplayOut "Enabling Cortana..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -ErrorAction SilentlyContinue
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 0 -ErrorAction SilentlyContinue
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 0 -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -ErrorAction SilentlyContinue
} ElseIf ($Cortana -eq 2) {
     DisplayOut "Disabling Cortana..." 12 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
}

# Cortana Search
If ($CortanaSearch -eq 1) {
     DisplayOut "Enabling Cortana Search..." 11 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue
} ElseIf ($CortanaSearch -eq 2) {
     DisplayOut "Disabling Cortana Search..." 12 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
}

# Error Reporting
If ($ErrorReporting -eq 1) {
     DisplayOut "Enabling Error reporting..." 11 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -ErrorAction SilentlyContinue
} ElseIf ($ErrorReporting -eq 2) {
     DisplayOut "Disabling Error reporting..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
}

# AutoLogger file and restrict directory
If ($AutoLoggerFile -eq 1) {
     DisplayOut "Unrestricting AutoLogger directory..." 11 0
     $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
     icacls $autoLoggerDir /grant:r SYSTEM:`(OI`)`(CI`)F | Out-Null
} ElseIf ($AutoLoggerFile -eq 2) {
     DisplayOut "Removing AutoLogger file and restricting directory..." 12 0
     $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
     If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
         Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
     }
     icacls $autoLoggerDir /deny SYSTEM:`(OI`)`(CI`)F | Out-Null
}

# Diagnostics Tracking Service
If ($DiagTrack -eq 1) {
     DisplayOut "Enabling and starting Diagnostics Tracking Service..." 11 0
     Set-Service "DiagTrack" -StartupType Automatic
     Start-Service "DiagTrack"
} ElseIf ($DiagTrack -eq 2) {
     DisplayOut "Stopping and disabling Diagnostics Tracking Service..." 12 0
     Stop-Service "DiagTrack"
     Set-Service "DiagTrack" -StartupType Disabled
}

# WAP Push Service
If ($WAPPush -eq 1) {
     DisplayOut "Enabling and starting WAP Push Service..." 11 0
     Set-Service "dmwappushservice" -StartupType Automatic
     Start-Service "dmwappushservice"
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\dmwappushservice" -Name "DelayedAutoStart" -Type DWord -Value 1
} ElseIf ($WAPPush -eq 1) {
     DisplayOut "Disabling WAP Push Service..." 12 0
     Stop-Service "dmwappushservice"
     Set-Service "dmwappushservice" -StartupType Disabled
}

# App Auto Download
If ($AppAutoDownload -eq 1) {
     DisplayOut "Enabling App Auto Download..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 0
     Remove-ItemProperty  -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures"  -ErrorAction SilentlyContinue
} ElseIf ($AppAutoDownload -eq 2) {
     DisplayOut "Disabling App Auto Download..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" -Name "AutoDownload" -Type DWord -Value 2
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
         New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
}

##########
# Privacy Settings -End
##########

##########
# Windows Update -Start
##########

DisplayOut ""
DisplayOut "-------------------------------" 14 0
DisplayOut "-   Windows Update Settings   -" 14 0
DisplayOut "-------------------------------" 14 0
DisplayOut ""

# Check for Windows Update
If ($CheckForWinUpdate -eq 1) {
     DisplayOut "Enabling Check for Windows Update..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "SetDisableUXWUAccess" -Type DWord -Value 0
} ElseIf ($CheckForWinUpdate -eq 2) {
     DisplayOut "Disabling Check for Windows Update..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "SetDisableUXWUAccess" -Type DWord -Value 1
}

# Windows Update Check Type
If ($WinUpdateType -ge 1 -and $WinUpdateType -le 4) {
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
         New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" | Out-Null
     }
     If ($WinUpdateType -eq 1){
         DisplayOut "Notify for windows update download and notify for install..." 16 0
         Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 2
     } ElseIf ($WinUpdateType -eq 2){
         DisplayOut "Auto Download for windows update download and notify for install..." 16 0
         Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 3
     } ElseIf ($WinUpdateType -eq 3){
         DisplayOut "Auto Download for windows update download and schedule for install..." 16 0
         Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 4
     } ElseIf ($WinUpdateType -eq 4){
         DisplayOut "Windows update allow local admin to choose setting..." 16 0
         Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type DWord -Value 5
     }
}

# Windows Update P2P
If ($WinUpdateDownload -eq 1) {
     DisplayOut "Unrestricting Windows Update P2P to internet..." 16 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -ErrorAction SilentlyContinue
} ElseIf ($WinUpdateDownload -eq 2) {
     DisplayOut "Restricting Windows Update P2P only to local network..." 16 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 1
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
} ElseIf ($WinUpdateDownload -eq 3) {
     DisplayOut "Disabling Windows Update P2P..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Type DWord -Value 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "SystemSettingsDownloadMode" -Type DWord -Value 3
}

##########
# Windows Update -End
##########

##########
# Service Tweaks -Start
##########

DisplayOut ""
DisplayOut "----------------------" 14 0
DisplayOut "-   Service Tweaks   -" 14 0
DisplayOut "----------------------" 14 0
DisplayOut ""

# UAC level
If ($UAC -eq 1) {
     DisplayOut "Lowering UAC level..." 16 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 0
} ElseIf ($UAC -eq 2) {
     DisplayOut "Normal UAC level..." 16 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -ErrorAction SilentlyContinue
} ElseIf ($UAC -eq 3) {
     DisplayOut "Raising UAC level..." 16 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1
}

# Sharing mapped drives between users
If ($SharingMappedDrives -eq 1) {
     DisplayOut "Enabling sharing mapped drives between users..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -Type DWord -Value 1
} ElseIf ($SharingMappedDrives -eq 2) {
     DisplayOut "Disabling sharing mapped drives between users..." 12 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLinkedConnections" -ErrorAction SilentlyContinue
}

# Administrative shares
If ($AdminShares -eq 1) {
     DisplayOut "Enabling implicit administrative shares..." 11 0
     Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -ErrorAction SilentlyContinue
} ElseIf ($AdminShares -eq 2) {
     DisplayOut "Disabling implicit administrative shares..." 12 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "AutoShareWks" -Type DWord -Value 0
}

# Firewall
If ($Firewall -eq 1) {
     DisplayOut "Enabling Firewall..." 11 0
     Set-NetFirewallProfile -Profile * -Enabled True
} ElseIf ($Firewall -eq 2) {
     DisplayOut "Disabling Firewall..." 12 0
     Set-NetFirewallProfile -Profile * -Enabled False
}

# Windows Defender
If ($WinDefender -eq 1) {
     DisplayOut "Enabling Windows Defender..." 11 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -ErrorAction SilentlyContinue
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -Type ExpandString -Value "`"%ProgramFiles%\Windows Defender\MSASCuiL.exe`""
} ElseIf ($WinDefender -eq 2) {
     DisplayOut "Disabling Windows Defender..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWord -Value 1
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefender" -ErrorAction SilentlyContinue
}

# Home Groups services
If ($HomeGroups -eq 1) {
     DisplayOut "Enabling  Home Groups services..." 11 0
     Set-Service "HomeGroupListener" -StartupType Manual
     Set-Service "HomeGroupProvider" -StartupType Manual
     Start-Service "HomeGroupProvider"
} ElseIf ($HomeGroups -eq 2) {
      DisplayOut "Disabling Home Groups services..." 12 0
     Stop-Service "HomeGroupListener"
     Set-Service "HomeGroupListener" -StartupType Disabled
     Stop-Service "HomeGroupProvider"
     Set-Service "HomeGroupProvider" -StartupType Disabled
}

# Remote Assistance
If ($RemoteAssistance -eq 1) {
     DisplayOut "Enabling Remote Assistance..." 11 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 1
} ElseIf ($RemoteAssistance -eq 2) {
     DisplayOut "Disabling Remote Assistance..." 12 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value 0
}

# Enable Remote Desktop w/o Network Level Authentication
If ($RemoteDesktop -eq 1) {
     DisplayOut "Enabling Remote Desktop w/o Network Level Authentication..." 11 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 0
} ElseIf ($RemoteDesktop -eq 2) {
     DisplayOut "Disabling Remote Desktop..." 12 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value 1
}

##########
# Service Tweaks -End
##########

##########
# Context Menu Items -Start
##########

DisplayOut ""
DisplayOut "--------------------------" 14 0
DisplayOut "-   Context Menu Items   -" 14 0
DisplayOut "--------------------------" 14 0
DisplayOut ""

# Cast to Device Context
If ($CastToDevice -eq 1) {
     DisplayOut "Enabling Cast to Device Context item..." 11 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -ErrorAction SilentlyContinue
} ElseIf ($CastToDevice -eq 2) {
     DisplayOut "Disabling Cast to Device Context item..." 12 0
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked")) {
         New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" | Out-Null
     }
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -ErrorAction SilentlyContinue
}

# Previous Versions Context Menu
If ($PreviousVersions -eq 1) {
     DisplayOut "Enabling Previous Versions Context item..." 11 0
     Set-ItemProperty -Path "HKCR:\ApplicationsAllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
     Set-ItemProperty -Path "HKCR:\ApplicationsCLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
     Set-ItemProperty -Path "HKCR:\ApplicationsDirectory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
     Set-ItemProperty -Path "HKCR:\ApplicationsDrive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force | Out-Null
} ElseIf ($PreviousVersions -eq 2) {
     DisplayOut "Disabling Previous Versions Context item..." 12 0
     Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKCR:\CLSID\{450D8FBA-AD25-11D0-98A8-0800361B1103}\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKCR:\Directory\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKCR:\Drive\shellex\ContextMenuHandlers\{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Recurse -ErrorAction SilentlyContinue
}

# Include in Library Context Menu
If ($IncludeinLibrary -eq 1) {
     DisplayOut "Enabling Include in Library Context item..." 11 0
     Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}"
} ElseIf ($IncludeinLibrary -eq 2) {
     DisplayOut "Disabling Include in Library..." 12 0
     Set-ItemProperty -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(Default)" -Type String -Value ""
}

# Pin To Context Menu
If ($PinTo -eq 1) {
     DisplayOut "Enabling Pin To Context item..." 11 0
     New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Force | Out-Null
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -Name "(Default)" -Type String -Value "Taskband Pin"
     New-Item -Path "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Force | Out-Null
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -Name "(Default)" -Type String -Value "Start Menu Pin"
     Set-ItemProperty -Path "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
     Set-ItemProperty -Path "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
     Set-ItemProperty -Path "HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
     Set-ItemProperty -Path "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value "{470C0EBD-5D73-4d58-9CED-E91E22E23282}"
} ElseIf ($PinTo -eq 2) {
     DisplayOut "Disabling Pin To Context item..." 12 0
     Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{90AA3A4E-1CBA-4233-B8BB-535773D48449}" -ErrorAction SilentlyContinue -Force
     Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\{a2a9545d-a0c2-42b4-9708-a0b2badd77c8}" -ErrorAction SilentlyContinue -Force
     Set-ItemProperty -Path "HKCR:\Folder\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\exefile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Microsoft.Website\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\mscfile\shellex\ContextMenuHandlers\PintoStartScreen" -Name "(Default)" -Type String -Value ""
}

# Share With Context Menu
If ($ShareWith -eq 1) {
     DisplayOut "Enabling Share With Context item..." 11 0
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" 
     Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value "{40dd6e20-7c17-11ce-a804-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
     Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}"
}  ElseIf ($ShareWith -eq 2) {
     DisplayOut "Disabling Share With..." 12 0
     Set-ItemProperty -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value "" 
     Set-ItemProperty -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Directory\shellex\CopyHookHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Directory\shellex\PropertySheetHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
     Set-ItemProperty -Path "HKCR:\LibraryFolder\background\shellex\ContextMenuHandlers\Sharing" -Name "(Default)" -Type String -Value ""
}

# Send To Context Menu
If ($SendTo -eq 1) {
     DisplayOut "Enabling Send To Context item..." 11 0
     If (!(Test-Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo")) {
         New-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo"
     }
     Set-ItemProperty -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -Name "(Default)" -Type String -Value "{7BA4C740-9E81-11CF-99D3-00AA004AE837}" -ErrorAction SilentlyContinue | Out-Null
} ElseIf ($SendTo -eq 2) {
     DisplayOut "Disabling Send To Context item..." 12 0
     If (Test-Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo") {
         Remove-Item -Path "HKCR:\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo" -ErrorAction SilentlyContinue
     }
}

##########
# Context Menu Items -End
##########

##########
# Task Bar Items -Start
##########

DisplayOut ""
DisplayOut "----------------------" 14 0
DisplayOut "-   Task Bar Items   -" 14 0
DisplayOut "----------------------" 14 0
DisplayOut ""

# Battery UI Bar
If ($BatteryUIBar -eq 1) {
     DisplayOut "Enabling New Battery UI Bar..." 16 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32BatteryFlyout" -ErrorAction SilentlyContinue
} ElseIf ($BatteryUIBar -eq 2) {
     DisplayOut "Enabling Old Battery UI Bar..." 16 0
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell")) {
         New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32BatteryFlyout" -Type DWord -Value 1
}

# Clock UI Bar
If ($ClockUIBar -eq 1) {
     DisplayOut "Enabling New Clock UI Bar..." 16 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32TrayClockExperience" -ErrorAction SilentlyContinue
} ElseIf ($ClockUIBar -eq 2) {
     DisplayOut "Enabling Old Clock UI Bar..." 16 0
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "UseWin32TrayClockExperience" -Type DWord -Value 1
}
	 
# Volume Control Bar
If ($VolumeControlBar -eq 1) {
     DisplayOut "Enabling New Volume Bar (Horizontal)..." 16 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc" -ErrorAction SilentlyContinue
} ElseIf ($VolumeControlBar -eq 2) {
     DisplayOut "Enabling Classic Volume Bar (Vertical)..." 16 0
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name "EnableMtcUvc" -Type DWord -Value 0
}

# Taskbar Search button / box
If ($TaskbarSearchBox -eq 1) {
     DisplayOut "Showing Taskbar Search box / button..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -ErrorAction SilentlyContinue
} ElseIf ($TaskbarSearchBox -eq 2) {
     DisplayOut "Hiding Taskbar Search box / button..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type DWord -Value 0
}

# Task View button
If ($TaskViewButton -eq 1) {
     DisplayOut "Showing Task View button..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -ErrorAction SilentlyContinue
} ElseIf ($TaskViewButton -eq 2) {
     DisplayOut "Hiding Task View button..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0
}

# Taskbar Icon Size
If ($TaskbarIconSize -eq 1) {
     DisplayOut "Showing Normal icon size in taskbar..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -ErrorAction SilentlyContinue
} ElseIf ($TaskbarIconSize -eq 2) {
     DisplayOut "Showing Smaller icons in taskbar..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Type DWord -Value 1
}

# Taskbar Item Grouping
If ($TaskbarGrouping -eq 1) {
     DisplayOut "Never Group Taskbar Items..." 16 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 2
} ElseIf ($TaskbarGrouping -eq 2) {
     DisplayOut "Always Group Taskbar Items..." 16 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 0
} ElseIf ($TaskbarGrouping -eq 3) {
     DisplayOut "When Needed Group Taskbar Items..." 16 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 1
}

# Tray icons
If ($TrayIcons -eq 1) {
     DisplayOut "Showing all tray icons..." 11 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Type DWord -Value 0
} ElseIf ($TrayIcons -eq 2) {
     DisplayOut "Hiding tray icons..." 12 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -ErrorAction SilentlyContinue
}

# Seconds in Taskbar Clock
If ($SecondsInClock -eq 1) {
     DisplayOut "Showing Seconds in Taskbar Clock..." 16 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1
} ElseIf ($SecondsInClock -eq 2) {
     DisplayOut "Hiding Seconds in Taskbar Clock..." 16 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 0
}

# Last Active Click
If ($LastActiveClick -eq 1) {
     DisplayOut "Enabling Last Active Click..." 11 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 1
} ElseIf ($LastActiveClick -eq 2) {
     DisplayOut "Disabling Last Active Click..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Type DWord -Value 0
}

# Taskbar on multiple displays
If ($TaskBarOnMultiDisplay -eq 1) {
     DisplayOut "Showing Taskbar on multiple displays..." 11 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 1
} ElseIf ($TaskBarOnMultiDisplay -eq 2) {
     DisplayOut "Hiding Taskbar on multiple displays.." 12 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type DWord -Value 0
}

# Taskbar on multiple displays
If ($TaskbarButtOnDisplay -eq 1) {
     DisplayOut "Showing Taskbar buttons on all taskbars..." 16 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 0
} ElseIf ($TaskbarButtOnDisplay -eq 2) {
     DisplayOut "Showing Taskbar buttons on taskbar where window is open..." 16 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 2
} ElseIf ($TaskbarButtOnDisplay -eq 3) {
     DisplayOut "Showing Taskbar buttons on main taskbar and where window is open..." 16 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarMode" -Type DWord -Value 1
}

##########
# Task Bar Items -End
##########

##########
# Star Menu Items -Start
##########

DisplayOut ""
DisplayOut "-----------------------" 14 0
DisplayOut "-   Star Menu Items   -" 14 0
DisplayOut "-----------------------" 14 0
DisplayOut ""

# Web Search in Start Menu
If ($StartMenuWebSearch -eq 1) {
     DisplayOut "Enabling Bing Search in Start Menu..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -ErrorAction SilentlyContinue
} ElseIf ($StartMenuWebSearch -eq 2) {
     DisplayOut "Disabling Bing Search in Start Menu..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type DWord -Value 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
         New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type DWord -Value 1
}

# Start Menu suggestions
If ($StartSuggestions -eq 1) {
     DisplayOut "Enabling Start Menu suggestions..." 11 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 1
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 1
} ElseIf ($StartSuggestions -eq 2) {
     DisplayOut "Disabling Start Menu suggestions..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
}

# Most used apps in Start menu
If ($MostUsedAppStartMenu -eq 1) {
     DisplayOut "Showing Most used apps in Start Menu..." 11 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 1
} ElseIf ($MostUsedAppStartMenu -eq 2) {
     DisplayOut "Hiding Most used apps in Start Menu..." 12 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type DWord -Value 0
}

# Recent Items and Frequent Places
If ($RecentItemsFrequent -eq 1) {
     DisplayOut "Enabling Recent Items and Frequent Places..." 11 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "Start_TrackDocs" -Type DWord -Value 1
} ElseIf ($RecentItemsFrequent -eq 2) {
     DisplayOut "Disabling Recent Items and Frequent Places..." 12 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "Start_TrackDocs" -Type DWord -Value 0
}

##########
# Star Menu Items -End
##########

##########
# Explorer Items -Start
##########

DisplayOut ""
DisplayOut "----------------------" 14 0
DisplayOut "-   Explorer Items   -" 14 0
DisplayOut "----------------------" 14 0
DisplayOut ""

# Process ID on Title Bar
If ($PidInTitleBar -eq 1) {
     DisplayOut "Showing Process ID on Title Bar..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -Type DWord -Value 1
} ElseIf ($PidInTitleBar -eq 2) {
     DisplayOut "Hiding Process ID on Title Bar..." 12 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowPidInTitle" -ErrorAction SilentlyContinue
}

# Aero Snap
If ($AeroSnap -eq 1) {
     DisplayOut "Enabling Aero Snap..." 11 0
     Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 1
} ElseIf ($AeroSnap -eq 2) {
     DisplayOut "Disabling Aero Snap..." 12 0
     Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WindowArrangementActive" -Type DWord -Value 0
}

# Aero Shake
If ($AeroShake -eq 1) {
     DisplayOut "Enabling Aero Shake..." 11 0
     Remove-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -ErrorAction SilentlyContinue
} ElseIf ($AeroShake -eq 2) {
     DisplayOut "Disabling Aero Shake..." 12 0
     If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer")) {
         New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -Type DWord -Value 1
}

# File extensions
If ($KnownExtensions -eq 1) {
     DisplayOut "Showing known file extensions..." 11 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0
} ElseIf ($KnownExtensions -eq 2) {
     DisplayOut "Hiding known file extensions..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 1
}

# Hidden files
If ($HiddenFiles -eq 1) {
     DisplayOut "Showing hidden files..." 11 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
} ElseIf ($HiddenFiles -eq 2) {
     DisplayOut "Hiding hidden files..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 2
}

# System files
If ($SystemFiles -eq 1) {
     DisplayOut "Showing System files..." 11 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 1
} ElseIf ($SystemFiles -eq 2) {
     DisplayOut "Hiding System files..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Type DWord -Value 0
}

# Show This PC shortcut on desktop
If ($ThisPCOnDesktop -eq 1) {
     DisplayOut "Showing This PC shortcut on desktop..." 11 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 0
} ElseIf ($ThisPCOnDesktop -eq 2) {
     DisplayOut "Hiding This PC shortcut from desktop..." 12 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -ErrorAction SilentlyContinue
}

# Change default Explorer view
If ($ExplorerOpenLoc -eq 1) {
     DisplayOut "Changing default Explorer view to Quick Access..." 16 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -ErrorAction SilentlyContinue
} ElseIf ($ExplorerOpenLoc -eq 2) {
     DisplayOut "Changing default Explorer view to This PC..." 16 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
}

# Recent Files in Quick Access
If ($RecentFileQikAcc -eq 1) {
     DisplayOut "Showing Recent Files in Quick Access..." 11 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name "(Default)" -Type String -Value "Recent Items Instance Folder"
     If($OSType -eq 64) {
         Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Name "(Default)" -Type String -Value "Recent Items Instance Folder"
     }
} ElseIf ($RecentFileQikAcc -eq 2) {
     DisplayOut "Hiding Recent Files in Quick Access..." 12 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
} ElseIf ($RecentFileQikAcc -eq 3) {
     DisplayOut "Removeing Recent Files in Quick Access..." 15 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type DWord -Value 0
     Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKLM:SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Recurse -ErrorAction SilentlyContinue
}

# Frequent folders in Quick_access
If ($FrequentFoldersQikAcc -eq 1) {
     DisplayOut "Showing Frequent folders in Quick Access..." 11 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 1
} ElseIf ($FrequentFoldersQikAcc -eq 2) {
     DisplayOut "Hiding Frequent folders in Quick Access..." 12 0
     Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type DWord -Value 0
}

# Window Content while Dragging
If ($WinContentWhileDrag -eq 1) {
     DisplayOut "Showing Window Content while Dragging..." 11 0
     Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 1
} ElseIf ($WinContentWhileDrag -eq 2) {
     DisplayOut "Hiding Window Content while Dragging..." 12 0
     Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DragFullWindows" -Type DWord -Value 0
}

# Autoplay
If ($Autoplay -eq 1) {
     DisplayOut "Enabling Autoplay..." 11 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 0
} ElseIf ($Autoplay -eq 2) {
     DisplayOut "Disabling Autoplay..." 12 0
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1
}

# Autorun for all drives
If ($Autorun -eq 1) {
     DisplayOut "Enabling Autorun for all drives..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
} ElseIf ($Autorun -eq 2) {
     DisplayOut "Disabling Autorun for all drives..." 12 0
     If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
         New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255
}

##########
# Explorer Items -End
##########

##########
# 'This PC' items -Start
##########

DisplayOut ""
DisplayOut "-----------------------" 14 0
DisplayOut "-   'This PC' items   -" 14 0
DisplayOut "-----------------------" 14 0
DisplayOut ""

# Desktop icon in This PC
If ($DesktopIconInThisPC -eq 1) {
     DisplayOut "Showing Desktop icon in This PC..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($DesktopIconInThisPC -eq 2) {
     DisplayOut "Hiding Desktop icon from This PC..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Documents icon in This PC
If ($DocumentsIconInThisPC -eq 1) {
     DisplayOut "Showing Documents icon in This PC..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
}ElseIf ($DocumentsIconInThisPC -eq 2) {
     DisplayOut "Hiding Documents icon from This PC..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Downloads icon from This PC
If ($DownloadsIconInThisPC -eq 1) {
     DisplayOut "Showing Downloads icon in This PC..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($DownloadsIconInThisPC -eq 2) {
     DisplayOut "Hiding Downloads icon from This PC..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Music icon from This PC
If ($MusicIconInThisPC -eq 1) {
     DisplayOut "Showing Music icon in This PC..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($MusicIconInThisPC -eq 2) {
     DisplayOut "Hiding Music icon from This PC..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Pictures icon from This PC
If ($PicturesIconInThisPC -eq 1) {
     DisplayOut "Showing Pictures icon in This PC..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($PicturesIconInThisPC -eq 2) {
     DisplayOut "Hiding Pictures icon from This PC..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

# Hide Videos icon from This PC
If ($VideosIconInThisPC -eq 1) {
     DisplayOut "Showing Videos icon in This PC..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Show"
} ElseIf ($VideosIconInThisPC -eq 2) {
     DisplayOut "Hiding Videos icon from This PC..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
}

##########
# 'This PC' items -End
##########

##########
# Photo Viewer Settings -Start
##########

DisplayOut ""
DisplayOut "-----------------------------" 14 0
DisplayOut "-   Photo Viewer Settings   -" 14 0
DisplayOut "-----------------------------" 14 0
DisplayOut ""

# Photo Viewer association for bmp, gif, jpg, png and tif
If ($PVFileAssociation -eq 1) {
     DisplayOut "Setting Photo Viewer association for bmp, gif, jpg, png and tif..." 11 0
     ForEach ($type in @("Paint.Picture", "giffile", "jpegfile", "pngfile")) {
         New-Item -Path $("HKCR:\$type\shell\open") -Force | Out-Null
         New-Item -Path $("HKCR:\$type\shell\open\command") | Out-Null
         Set-ItemProperty -Path $("HKCR:\$type\shell\open") -Name "MuiVerb" -Type ExpandString -Value "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"
         Set-ItemProperty -Path $("HKCR:\$type\shell\open\command") -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
     }
} ElseIf ($PVFileAssociation -eq 2) {
     DisplayOut "Unsetting Photo Viewer association for bmp, gif, jpg, png and tif..." 12 0
     If (Test-Path "HKCR:\Paint.Picture\shell\open") {
         Remove-Item -Path "HKCR:\Paint.Picture\shell\open" -Recurse
     }
     Remove-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "MuiVerb" -ErrorAction SilentlyContinue
     Set-ItemProperty -Path "HKCR:\giffile\shell\open" -Name "CommandId" -Type String -Value "IE.File"
     Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "(Default)" -Type String -Value "`"$env:SystemDrive\Program Files\Internet Explorer\iexplore.exe`" %1"
     Set-ItemProperty -Path "HKCR:\giffile\shell\open\command" -Name "DelegateExecute" -Type String -Value "{17FE9752-0B5A-4665-84CD-569794602F5C}"
     If (Test-Path "HKCR:\jpegfile\shell\open") { 
         Remove-Item -Path "HKCR:\jpegfile\shell\open" -Recurse
     }
     If (Test-Path "HKCR:\jpegfile\shell\open") { 
         Remove-Item -Path "HKCR:\pngfile\shell\open" -Recurse
     }
} 

# Add Photo Viewer to "Open with..."
If ($PVOpenWithMenu -eq 1) {
     DisplayOut "Adding Photo Viewer to Open with Menu..." 11 0
     New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Force | Out-Null
     New-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Force | Out-Null
     Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Name "MuiVerb" -Type String -Value "@photoviewer.dll,-3043"
     Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\command" -Name "(Default)" -Type ExpandString -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
     Set-ItemProperty -Path "HKCR:\Applications\photoviewer.dll\shell\open\DropTarget" -Name "Clsid" -Type String -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
} ElseIf ($PVOpenWithMenu -eq 2) {
     DisplayOut "Removing Photo Viewer from Open with Menu..." 12 0
     If (Test-Path "HKCR:\Applications\photoviewer.dll\shell\open") {
         Remove-Item -Path "HKCR:\Applications\photoviewer.dll\shell\open" -Recurse
     }
}

##########
# Photo Viewer Settings -End
##########

##########
# Lockscreen Items -Start
##########

DisplayOut ""
DisplayOut "------------------------" 14 0
DisplayOut "-   Lockscreen Items   -" 14 0
DisplayOut "------------------------" 14 0
DisplayOut ""

# Lock screen
If ($LockScreen -eq 1) {
     DisplayOut "Enabling Lock screen..." 11 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -ErrorAction SilentlyContinue
} ElseIf ($LockScreen -eq 2) {
     DisplayOut "Disabling Lock screen..." 12 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
         New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Type DWord -Value 1
} 

# Lock screen (Anniversary Update workaround) - Applicable to RS1 or newer
If ($LockScreenAlt -eq 1) {
     DisplayOut "Enabling Lock screen (removing scheduler workaround)..." 11 0
     Unregister-ScheduledTask -TaskName "Disable LockScreen" -Confirm:$false -ErrorAction SilentlyContinue
} ElseIf ($LockScreenAlt -eq 2) {
     DisplayOut "Disabling Lock screen using scheduler workaround..." 12 0
     $service = New-Object -com Schedule.Service
     $service.Connect()
     $task = $service.NewTask(0)
     $task.Settings.DisallowStartIfOnBatteries = $false
     $trigger = $task.Triggers.Create(9)
     $trigger = $task.Triggers.Create(11)
     $trigger.StateChange = 8
     $action = $task.Actions.Create(0)
     $action.Path = "reg.exe"
     $action.Arguments = "add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData /t REG_DWORD /v AllowLockScreen /d 0 /f"
     $service.GetFolder("\").RegisterTaskDefinition("Disable LockScreen", $task, 6, "NT AUTHORITY\SYSTEM", $null, 4) | Out-Null
}

# Power Menu on Lock Screen
If ($PowerMenuLockScreen -eq 1) {
     DisplayOut "Showing Power Menu on Lock Screen..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 1
} ElseIf ($PowerMenuLockScreen -eq 2) {
     DisplayOut "Hiding Power Menu on Lock Screen..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "shutdownwithoutlogon" -Type DWord -Value 0
}

# Camera at Lockscreen
If ($CameraOnLockscreen -eq 1) {
     DisplayOut "Enabling Camera at Lockscreen..." 11 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera" -ErrorAction SilentlyContinue
} ElseIf ($CameraOnLockscreen -eq 2) {
     DisplayOut "Disabling Camera at Lockscreen..." 12 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization")) {
         New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreenCamera" -Type DWord -Value 1
}

##########
# Lockscreen Items -End
##########

##########
# Misc Items -Start
##########

DisplayOut ""
DisplayOut "------------------" 14 0
DisplayOut "-   Misc Items   -" 14 0
DisplayOut "------------------" 14 0
DisplayOut ""

# Action Center
If ($ActionCenter -eq 1) {
     DisplayOut "Enabling Action Center..." 11 0
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -ErrorAction SilentlyContinue
     Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue
} ElseIf ($ActionCenter -eq 2) {
     DisplayOut "Disabling Action Center..." 12 0
     If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
         New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" | Out-Null
     }
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Type DWord -Value 1
     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Type DWord -Value 0
}

# Sticky keys prompt
If ($StickyKeyPrompt -eq 1) {
     DisplayOut "Enabling Sticky keys prompt..." 11 0
     Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "510"
} ElseIf ($StickyKeyPrompt -eq 2) {
     DisplayOut "Disabling Sticky keys prompt..." 12 0
     Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
}

# NumLock after startup
If ($NumblockOnStart -eq 1) {
     DisplayOut "Enabling NumLock after startup..." 11 0
     Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483650
} ElseIf ($NumblockOnStart -eq 2) {
     DisplayOut "Disabling NumLock after startup..." 12 0
     Set-ItemProperty -Path "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type DWord -Value 2147483648
}

# Enable F8 boot menu options
If ($F8BootMenu -eq 1) {
     DisplayOut "Enabling F8 boot menu options..." 11 0
     bcdedit /set `{current`} bootmenupolicy Legacy | Out-Null
} ElseIf ($F8BootMenu -eq 2) {
     DisplayOut "Disabling F8 boot menu options..." 12 0
     bcdedit /set `{current`} bootmenupolicy Standard | Out-Null
}

# Remote UAC Local Account Token Filter
If ($RemoteUACAcctToken -eq 1) {
     DisplayOut "Enabling Remote UAC Local Account Token Filter..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Type DWord -Value 1
} ElseIf ($RemoteUACAcctToken -eq 2) {
     DisplayOut "Disabling  Remote UAC Local Account Token Filter..." 12 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -ErrorAction SilentlyContinue
}

# Hibernate Option
If ($HibernatePower -eq 1) {
     DisplayOut "Enabling Hibernate Option..." 11 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 1
} ElseIf ($HibernatePower -eq 2) {
     DisplayOut "Disabling Hibernate Option..." 12 0
     Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Type DWord -Value 0
}

# Sleep Option
If ($SleepPower -eq 1) {
     DisplayOut "Enabling Sleep Option..." 11 0
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings")) {
          New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowSleepOption" -Type DWord -Value 1
} ElseIf ($SleepPower -eq 2) {
     DisplayOut "Disabling Sleep Option..." 12 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowSleepOption" -Type DWord -Value 0
}

##########
# Misc Items -End
##########

##########
# Application Items -Start
##########

DisplayOut ""
DisplayOut "-------------------------" 14 0
DisplayOut "-   Application Items   -" 14 0
DisplayOut "-------------------------" 14 0
DisplayOut ""

# OneDrive
If ($OneDrive -eq 1) {
     DisplayOut "Enabling OneDrive..." 11 0
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -ErrorAction SilentlyContinue
} ElseIf ($OneDrive -eq 2) {
     DisplayOut "Disabling OneDrive..." 12 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive")) {
         New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type DWord -Value 1
}

# OneDrive Install
If ($OneDriveInstall -eq 1) {
     DisplayOut "Installing OneDrive..." 11 0
     If($OSType -eq 64) {
         $onedriveS = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
     } Else {
         $onedriveS = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
     }
     Start-Process $onedriveS -NoNewWindow
} ElseIf ($OneDriveInstall -eq 2) {
     DisplayOut "Uninstalling OneDrive..." 15 0
     Stop-Process -Name OneDrive -ErrorAction SilentlyContinue
     Start-Sleep -s 3
     If($OSType -eq 64) {
         $onedriveS = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
     } Else {
         $onedriveS = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
     }
     Start-Process $onedriveS "/uninstall" -NoNewWindow -Wait | Out-Null
     Start-Sleep -s 3
     Stop-Process -Name explorer -ErrorAction SilentlyContinue
     Start-Sleep -s 3
     Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
     Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
     Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
     If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
         Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse -ErrorAction SilentlyContinue
     }
     Remove-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
     Remove-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Recurse -ErrorAction SilentlyContinue
}

# Xbox DVR
If ($XboxDVR -eq 1) {
     DisplayOut "Enabling Xbox DVR..." 11 0
     Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 1
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
} ElseIf ($XboxDVR -eq 2) {
     DisplayOut "Disabling Xbox DVR..." 12 0
     Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Type DWord -Value 0
     If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR")) {
         New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" | Out-Null
     }
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type DWord -Value 0
}

# Windows Media Player
If ($MediaPlayer -eq 1) {
     DisplayOut "Installing Windows Media Player..." 11 0
     dism /online /Enable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
} ElseIf ($MediaPlayer -eq 2) {
     DisplayOut "Uninstalling Windows Media Player..." 14 0
     dism /online /Disable-Feature /FeatureName:MediaPlayback /Quiet /NoRestart
}

# Work Folders Client
If ($WorkFolders -eq 1) {
     DisplayOut "Installing Work Folders Client..." 11 0
     dism /online /Enable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
} ElseIf ($WorkFolders -eq 2) {
     DisplayOut "Uninstalling Work Folders Client..." 14 0
     dism /online /Disable-Feature /FeatureName:WorkFolders-Client /Quiet /NoRestart
}

# Install Linux Subsystem - Applicable to RS1 or newer
If ($LinuxSubsystem -eq 1) {
     DisplayOut "Installing Linux Subsystem..." 11 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 1
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 1
     dism /online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /Quiet /NoRestart
} ElseIf ($LinuxSubsystem -eq 2) {
     DisplayOut "Uninstalling Linux Subsystem..." 14 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Type DWord -Value 0
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowAllTrustedApps" -Type DWord -Value 0
     dism /online /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux /Quiet /NoRestart
}

##########
# Application Items -end
##########

##########
# Metro App Items -Start
##########

DisplayOut ""
DisplayOut "-----------------------" 14 0
DisplayOut "-   Metro App Items   -" 14 0
DisplayOut "-----------------------" 14 0
DisplayOut ""

# Default Microsoft applications (Bloatware)
DisplayOut "" 14 0
DisplayOut "Installing Apps..." 11 0
DisplayOut "------------------" 11 0
DisplayOut "" 14 0
ForEach ($AppI in $APPS_AppsInstall) {
     #$APPIDisplay = "Installing "+$AppI+"..."
     #DisplayOut $APPIDisplay 11 0
	 DisplayOut $AppI 11 0
     Add-AppxPackage -DisableDevelopmentMode -Register "$($(Get-AppXPackage -AllUsers "$AppI").InstallLocation)\AppXManifest.xml"
}
DisplayOut "" 12 0
DisplayOut "Hidinging Apps..." 12 0
DisplayOut "-----------------" 12 0
DisplayOut "" 14 0
ForEach ($AppH in $APPS_AppsHide) {
     #$APPHDisplay = "Hidinging "$AppH"..."
     #DisplayOut $APPHDisplay 12 0
	 DisplayOut $AppH 12 0
     Get-AppxPackage $AppH | Remove-AppxPackage
}
DisplayOut "" 14 0
DisplayOut "Uninstalling Apps..." 14 0
DisplayOut "--------------------" 14 0
DisplayOut "" 14 0
ForEach ($AppU in $APPS_AppsUninstall) {
     #$APPUDisplay = "Uninstalling "+$AppU+"..."
     #DisplayOut $APPUDisplay 14 0
     DisplayOut $AppU 14 0
     $PackageFullName = (Get-AppxPackage $AppU).PackageFullName
     $ProPackageFullName = (Get-AppxProvisionedPackage -online | where {$_.Displayname -eq $AppU}).PackageName
     
     # Alt removal
     # DISM /Online /Remove-ProvisionedAppxPackage /PackageName:            
     If ($PackageFullName) {
         Remove-AppxPackage -package $PackageFullName
     }
     If ($ProPackageFullName) {
         Remove-AppxProvisionedPackage -online -packagename $ProPackageFullName
     }
}

##########
# Metro App Items -End
##########

##########
# Disabled Items -Start
##########

# More Tile Colors
# Error of:
# Set-ItemProperty : Cannot convert value "00918b73" to type "System.UInt32". Error: "Input string was not in a correctformat."
If ($Disabled -eq 1) {
If ($MoreColorsTitle -eq 1) {
     DisplayOut "Enabling More Tile Colors..." 11 0
     If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\")) {
	    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\" | Out-Null
     }
     for($i=0; $i -ne 4; $i++) {
	    If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\$i\")) {
	             New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\$i\" | Out-Null
	    }
	    for($a=0; $a -ne 2; $a++) {
	         If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\$i\Theme$a")) {
	             New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\$i\Theme$a" | Out-Null
	         } 
	     }
     }
     New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\0\Theme0"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\0\Theme0" -Name "Color" -Type DWord -Value "00918b73"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\0\Theme1" -Name "Color" -Type DWord -Value "00a68e5e"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\1\Theme0" -Name "Color" -Type DWord -Value "00a44817"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\1\Theme1" -Name "Color" -Type DWord -Value "00618a28"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\2\Theme0" -Name "Color" -Type DWord -Value "00bab4ab"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\2\Theme1" -Name "Color" -Type DWord -Value "00bab4ab"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\3\Theme0" -Name "Color" -Type DWord -Value "0085bd37"
     Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents\3\Theme1" -Name "Color" -Type DWord -Value "0085bd37"
} ElseIf ($MoreColorsTitle -eq 2) {
     DisplayOut "Disabling More Tile Colors..." 12 0
     Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Accents" -Force -Recurse -ErrorAction SilentlyContinue
}
}

##########
# Disabled Items -End
##########

##########
# In Testing Items -Start
##########



##########
# In Testing Items -End
##########

##########
# End Script -Start
##########
If ($Restart -eq 1) {
     Write-Host "Restarting in 10 Seconds..."
     Start-Sleep -s 10
     Restart-Computer
} Else {
     Write-Host "Goodbye..."
}

##########
# End Script -End
##########
