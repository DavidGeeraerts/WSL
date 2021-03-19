# [Windows Subsystem for Linux Version 2](https://docs.microsoft.com/en-us/windows/wsl/)


1. Add the following Windows features:
	- Windows Subsystem for Linux (WSL required)

	`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`

	- Virtual Machine Platform (WSL2)

	`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`

2. Windows needs to be rebooted.

	`shutdown /r /t 10 /c "WSL Setup" /d p:2:4`

3. Install [Linux Kernel update package](https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package)


	[_Direct link to msi_](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi)

```
	cd %PUBLIC%\Downloads
	wget "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
	wsl_update_x64.msi /passive /q /forcerestart
```

4. Set WSL 2 as default
	
	`wsl --set-default-version 2`

5. [Install Linux distro's from Microsoft Store](https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-6---install-your-linux-distribution-of-choice)

	[MS WSL Store](https://aka.ms/wslstore)

	`wsl --list --online` # Doesn't work

	[Chocolatey Repo](https://chocolatey.org/packages?q=WSL)

	[_Requires Chocolatey to be installed!_](https://docs.chocolatey.org/en-us/choco/setup#install-from-powershell-v3)

	```
	choco install wsl-alpine /y
	choco install wsl-ubuntu-2004 /y
	choco install wsl-archlinux /y
	choco install wsl-fedoraremix /y
	choco install wsl-debiangnulinux /y
	choco install wsl-kalilinux /y
	choco install wsl-opensuse /y
	choco wsl-kalilinux wsl-opensuse /y
	```

Install multiple at once:

	choco install wsl-alpine wsl-ubuntu-2004 wsl-archlinux wsl-fedoraremix wsl-debiangnulinux /y

6. Set username and password for distro

7. Update distribution with package manager

	[**Debian Lineage**]

	`apt update`

	`apt upgrade`

	[**RHEL Lineage**]

	`dnf upgrade --refresh`

	[**Alpine Lineage**]

	`apk update`

	`apk upgrade`

### Notes:
- all files by default are located in the user profile:

	`C:\Users\<user>\AppData\Local\Packages`

- main file is a virtual harddisk: **ext4.vhdx**
 
- Change location for a distro

	[EXPORT]

	`wsl.exe --export <Distro> <FileName>`

	[IMPORT]

	`wsl.exe --import <Distro> <InstallLocation> <FileName> [Options]`

- To access wsl linux distro file system from Windows

	`\\wsl$\<distroName>`

- LAN Networking (port proxy)

	`netsh interface portproxy add v4tov4 listenport=<port#> listenaddress=0.0.0.0 connectport=<port#> connectaddress=<VM IP Address>`

	e.g. `netsh interface portproxy add v4tov4 listenport=4000 listenaddress=0.0.0.0 connectport=4000 connectaddress=192.168.101.100`

- Default storage capacity is up to 256 GB

	To expand, follow the following [instructions.](https://docs.microsoft.com/en-us/windows/wsl/compare-versions#expanding-the-size-of-your-wsl-2-virtual-hard-disk)
		

#### Limitations
- Cross file system is slow, i.e. linux internally using windows files.
- no pre-built CENTOS distro
- no IPv6 support