# WSL (Windows Subsystem for Linux) User Guide

[Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)


### Copy / Paste

Simply copy outside the container, then:  
`right-click` with mouse inside the container shell/terminal.


### Connect to Windows network file share

\# Create a mount point within the Linux container

`sudo mkdir /mnt/share`

\# Connect the mount point to a windows network file share

`sudo mount -t drvfs '\\Server\Share' /mnt/share`