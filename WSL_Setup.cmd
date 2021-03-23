:::: Windows Subsystem for Linux [WSL] ::::

::#############################################################################
::							#DESCRIPTION#
::
::	SCRIPT STYLE: Interactive
::	Automated installation and setup for Windows Subsystem for Linux (WSL)
::	
::#############################################################################

:::: Developer ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author:		David Geeraerts
:: Location:	Olympia, Washington USA
:: E-Mail:		dgeeraerts.evergreen@gmail.com
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: GitHub :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::	https://github.com/cal-sc/WSL
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: License ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Copyleft License(s)
:: GNU GPL v3 (General Public License)
:: https://www.gnu.org/licenses/gpl-3.0.en.html
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Versioning Schema ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::		VERSIONING INFORMATION												 ::
::		Semantic Versioning used											 ::
::		http://semver.org/													 ::
::		Major.Minor.Revision												 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Command shell ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@Echo Off
@SETLOCAL enableextensions
SET $PROGRAM_NAME=WSL_Setup
SET $Version=1.1.0
SET $BUILD=2021-03-23 10:00
Title %$PROGRAM_NAME%
Prompt WSL$G
color 8F
mode con:cols=75 lines=40
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Configuration - Basic ::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Declare Global variables
:: All User variables are set within here.
:: Defaults
::	uses user profile location for logs
SET "$LOGPATH=%APPDATA%\WSL"
SET "$LOG=WSL_Setup.log
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:::: Configuration - Advanced :::::::::::::::::::::::::::::::::::::::::::::::::
:: Advanced Settings

:: DEBUG
:: {0 [Off/No] , 1 [On/Yes]}
SET $DEGUB_MODE=0


::#############################################################################
::	!!!!	Everything below here is 'hard-coded' [DO NOT MODIFY]	!!!!
::#############################################################################


:::: Default Program Variables ::::::::::::::::::::::::::::::::::::::::::::::::
:: Program Variables
SET $STATUS_ADMIN=
SET $STATUS_VT=
SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=
SET $STATUS_VIRTUALMACHINEPLATFORM=
SET $STATUS_REBOOT=
SET $STATUS_WSL_KERNEL_UPDATE=
SET $STATUS_WSL_DEFAULT_VERSION=

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Check if complete ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
IF EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" GoTo end
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Directory ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:CD
	:: Launched from directory
	SET "$PROGRAM_PATH=%~dp0"
	::	Setup logging
	IF NOT EXIST "%$LOGPATH%\var" MD "%$LOGPATH%\var"
	cd /D "%$PROGRAM_PATH%"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Administrator Privilege Check ::::::::::::::::::::::::::::::::::::::::::::
:subA
	SET $ADMIN_STATUS=0
	openfiles.exe 1> "%$LOGPATH%\var\var_$Admin_Status_M.txt" 2> "%$LOGPATH%\var\var_$Admin_Status_E.txt" && (SET $ADMIN_STATUS=1)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

Goto start

:::: banner :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:banner
:: CONSOLE MENU ::
cls
	echo  ********************************************************************
	echo		Windows Subsystem for Linux [WSL]
	echo			Version: %$Version%
	IF %$DEGUB_MODE% EQU 1 echo			Build: %$BUILD%
	echo.
	echo		 	%DATE% %TIME%
	echo.
	echo  ********************************************************************
echo.
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: HUD ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:HUD
echo --------------------------------------------------------------------
echo	Part I
echo		Administrative Privelage: %$STATUS_ADMIN%
echo 	Virtualization: %$STATUS_VT%
echo 	Feature Microsoft-Windows-Subsystem-Linux: %$STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX%
echo		Feature VirtualMachinePlatform: %$STATUS_VIRTUALMACHINEPLATFORM%
echo		Reboot: %$STATUS_REBOOT%
echo --------------------------------------------------------------------
echo.
echo	Part II
echo		WSL Kernel update: %$STATUS_WSL_KERNEL_UPDATE%
echo		Set WSL Default version [2]: %$STATUS_WSL_DEFAULT_VERSION%
echo --------------------------------------------------------------------
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Start ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:start
	CALL :banner
	CALL :HUD
	echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Admin Privelage Check ::::::::::::::::::::::::::::::::::::::::::::::::::::
:admin
	echo Checking if running with Administrative privelage...
	echo (Running with Administrative privelage is required!)
	echo.
	IF %$ADMIN_STATUS% EQU 1 (
		echo Running with Administrative privelage!
		SET $STATUS_ADMIN=Pass
		)
		
	IF %$ADMIN_STATUS% EQU 0 (
		color 4E
		echo NOT running with  Administrative privelage!
		echo Right-click script, "Run as administrator"!
		echo Script will now abort!
		echo.
		SET $STATUS_ADMIN=FAILED
		pause
		GoTo end
		)
	echo.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:checkPI
IF EXIST "%$LOGPATH%\var\Part-I-Reboot.txt" (
	SET $STATUS_VT=Done
	SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=Done
	SET $STATUS_VIRTUALMACHINEPLATFORM=Done
	SET $STATUS_REBOOT=Done
	GoTo PartII
	)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::Virtualization Check ::::::::::::::::::::::::::::::::::::::::::::::::::::::
:VT
	CALL :banner
	CALL :HUD
SET $VT_CHECK=0

echo.
echo Checking to see if:
echo	[VT] Virtualization Enabled In Firmware (BIOS) is turned on...
echo.
wmic CPU GET VirtualizationFirmwareEnabled /VALUE > "%$LOGPATH%\var\$VirtualizationFirmwareEnabled.txt"
wmic CPU GET VMMonitorModeExtensions /VALUE > "%$LOGPATH%\var\$VMMonitorModeExtensions.txt"
wmic CPU GET SecondLevelAddressTranslationExtensions /VALUE > "%$LOGPATH%\var\$SecondLevelAddressTranslationExtensions.txt"
find /I "VirtualizationFirmwareEnabled=TRUE" "%$LOGPATH%\var\$VirtualizationFirmwareEnabled.txt" 1> nul 2> nul && (SET $VT_CHECK=1)
echo %$VT_CHECK% > "%$LOGPATH%\var\$VT_CHECK.txt"
IF %$VT_CHECK% EQU 1 ECHO Virtualization Enabled in the firmware, i.e. BIOS!
SET $STATUS_VT=Check
echo.
IF %$VT_CHECK% EQU 1 GoTo skipVT
	echo Hyper-V virtualization not detected!
	echo Searching for hypervisor...
	systeminfo | FIND /I "Hyper-V Requirements:" > "%$LOGPATH%\var\$HYPER-V_REQUIREMENTS.txt"
	SET $HYPERVISOR=0
	echo $HYPERVISOR: %$HYPERVISOR% > "%$LOGPATH%\var\$HYPERVISOR.txt"
	FIND /I "A hypervisor has been detected." "%$LOGPATH%\var\$HYPER-V_REQUIREMENTS.txt" 1> nul 2> nul && (SET $HYPERVISOR=1)
	IF %$HYPERVISOR% EQU 0 GoTo skipHypervisor
	echo A non-hyper-V hypervisor has been detected!
	echo Do you want to proceed anyway?
	Choice /C YN /T 60 /D Y /m "[Y]es or [N]o":
	IF %ERRORLEVEL% EQU 2 GoTo errHyper
	IF %ERRORLEVEL% EQU 1 GoTo skipVT	
	
:errHyper
	color 4E
	echo Virtualization disabled in the firmware ^(BIOS^)!
	echo ...or non-Hyper-V hypervisor detected! 
	echo.
	echo Virtualization is required for Hyper-V and WSL!
	echo Turn on [VT] Virtualization in the BIOS.
	echo Script will now abort!
	echo.
	SET $STATUS_VT=FAILED
	PAUSE
	GoTo end

:skipVT
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CALL :banner
CALL :HUD
IF DEFINED ChocolateyInstall GoTo skipChoco
echo Install Chocolatey, Windows package manager?
echo (Linux distro's can be installed via Chocolatey!)
echo.
Choice /c YN /m "[Y]es or [N]o":
	IF %ERRORLEVEL% EQU 2 GoTo skipChoco
	IF %ERRORLEVEL% EQU 1 GoTo Choco_I

:Choco_I
CALL Install_Chocolatey.cmd
:skipChoco
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CALL :banner
CALL :HUD
	
:::: DISM :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Dism /online /Get-FeatureInfo /FeatureName:Microsoft-Windows-Subsystem-Linux > "%$LOGPATH%\var\$FEATURE_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX.txt"
FIND /I "State : Enabled" "%$LOGPATH%\var\$FEATURE_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX.txt" 1> nul 2> nul && (SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=Check) && GoTo skipFMWSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
SET $STATUS_MICROSOFT-WINDOWS-SUBSYSTEM-LINUX=Done
:skipFMWSL

CALL :banner
CALL :HUD
Dism /online /Get-FeatureInfo /FeatureName:VirtualMachinePlatform > "%$LOGPATH%\var\$VIRTUALMACHINEPLATFORM.txt"
FIND /I "State : Enabled" "%$LOGPATH%\var\$VIRTUALMACHINEPLATFORM.txt" 1> nul 2> nul && (SET $STATUS_VIRTUALMACHINEPLATFORM=Check) && GoTo skipVMP
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
SET $STATUS_VIRTUALMACHINEPLATFORM=Done
:skipVMP
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

CALL :banner
CALL :HUD

IF EXIST "%$LOGPATH%\var\Part-I-Reboot.txt" (SET $STATUS_REBOOT=Check) && GoTo skipReboot
echo WSL Setup reboot: %DATE% %TIME% > "%$LOGPATH%\var\Part-I-Reboot.txt"
SET $STATUS_REBOOT=Rebooting
shutdown /r /t 10 /c "WSL Setup" /d p:2:4
echo.
CALL :banner
CALL :HUD
echo.
PAUSE
:skipReboot
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:PartII
CALL :banner
CALL :HUD
echo.
cd %PUBLIC%\Downloads
IF EXIST "%$LOGPATH%\wsl_update_x64.log" SET $STATUS_WSL_KERNEL_UPDATE=Check
FIND /I "Installation completed successfully." "%APPDATA%\WSL\wsl_update_x64.log" 2> nul
SET $WSL_KERNEL_UPDATE_STATUS=%ERRORLEVEL%
IF %$WSL_KERNEL_UPDATE_STATUS% EQU 0 (
	SET $STATUS_WSL_KERNEL_UPDATE=Done
	GoTo skipWSLKU
	)
IF EXIST "%PUBLIC%\Downloads\wsl_update_x64.msi" GoTo skipWSLKU
:: wmic product GET name /VALUE | FIND /I "Name=Windows Subsystem for Linux Update"
wget -V 1> nul 2>nul
SET $WGET_STATUS=%ERRORLEVEL%
IF %$WGET_STATUS% EQU 0 GoTo subWGET
echo Use WGET or CURL to download WSL Kernel Update?
Choice /C WC /T 60 /D C /m "[W]GET or [C]URL":
	IF %ERRORLEVEL% EQU 2 GoTo subCURL
	IF %ERRORLEVEL% EQU 1 GoTo subWGET
	
:subCURL
echo.
curl -V 2> nul > "%$LOGPATH%\var\CURL_VERSION.txt"
curl https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi  > %PUBLIC%\Downloads\wsl_update_x64.msi
wsl_update_x64.msi /passive /q /norestart /log "%$LOGPATH%\wsl_update_x64.log"
GoTo skipWSLKU

:subWGET
echo.
wget -V 2> nul > "%$LOGPATH%\var\WGET_VERSION.txt"
IF %ERRORLEVEL% NEQ 0 GoTo errWGET
IF NOT EXIST "wsl_update_x64.msi" wget "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
wsl_update_x64.msi /passive /q /norestart /log "%$LOGPATH%\wsl_update_x64.log"
SET $STATUS_WSL_KERNEL_UPDATE=Done

:skipWSLKU
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:Conf
CALL :banner
CALL :HUD

wsl --set-default-version 2
SET $STATUS_WSL_DEFAULT_VERSION=Done
echo WSL Setup Part-II: %DATE% %TIME% > "%$LOGPATH%\var\Part-II-Complete.txt"
IF EXIST "%$LOGPATH%\var\Part-II-Complete.txt" echo WSL Setup completed: %DATE% %TIME% > "%$LOGPATH%\WSL-Setup_Complete.txt"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: jump Error section
GoTo end
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:errWGET
color 4E
echo WGET missing!
echo.
echo Install WGET from chocolatey repository?
Choice /c YN /m "[Y]es or [N]o":
	IF %ERRORLEVEL% EQU 2 GoTo end
	IF %ERRORLEVEL% EQU 1 GoTo WGET_I
:WGET_I
choco install wget /Y
GoTo PartII
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



:End
IF EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" IF %$DEGUB_MODE% EQU 0 RD /S /Q "%$LOGPATH%\var"
CALL :banner
CALL :HUD
echo.
IF EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" (
	color 0A
	echo WSL Setup Completed!
	)
IF NOT EXIST "%$LOGPATH%\WSL-Setup_Complete.txt" echo WSL Setup is not complete!
echo.
timeout /t 60
exit
