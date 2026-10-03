# HomeLab Summary
This personal project documents the configuration, security policies, and automation script for my centralized Linux home server that I built myself in 2023. 

This server acts as a multi-purpose machine offering game server hosting, remote desktop capabilities, and running automated startup and backups.

## Table Of Contents
- [Operating System & Specs](#operating-system--specs)
- [Remote Access](#remote-access)
- [Security & Hardening](#security--hardening)
- [Network & Port Forward Configuration](#network--port-forward-configuration)
- [Game Hosting & Automation](#game-hosting--automation)
- [Backup & Recovery](#backup--recovery)
- [Lessons Learned](#lessons-learned)
  
- [Future Improvements](#future-improvements)
  
##  Operating System & Specs

* **Operating System:** Linux Mint
   * **CPU:** Intel i7-9700f
   * **RAM:** 32GB DDR4
   * **STORAGE:** 500gb SSD, 2TB HDD

Parts selection are a combination of used and donated components. Only storage drives were purchased brand new.

Below is a snippet of the system info:

<img width="694" height="375" alt="neofetch" src="https://github.com/user-attachments/assets/0f4b42f9-c747-4238-abb9-b03f638c32e3" />

## Remote Access 
[ThinLinc](https://www.cendio.com/) is a free VNC remote access solution that provides a Graphical User Interface (GUI) when connecting remotely via OpenSSH through the Thinlinc Client application. 
This software fit my requirements to have full control of my desktop interface. I can access my server within my Local Area Network (LAN) or securely outside of my network.

## Security & Hardening
To ensure system hardening, I took the following steps:
* **Patch Management:** The Linux OS is updated weekly with the latest security patches.
  
* **Firewall Hardening:** The Uncomplicated Firewall (UFW) is enabled, blocking all traffic except for explicitly whitelisted ports required for active services.

* **Brute-Force Protection:** Fail2Ban dynamically monitors access logs and automatically blacklists unknown IP addresses attempting brute-force attacks.
  
* **Traffic Encryption:** Because ThinLinc relies on OpenSSH, all client-to-server traffic is natively encrypted through secure SSH tunneling.
  
*  **Reverse Proxy:** My server uses [Playit.GG](https://playit.gg/) which uses proxy servers to tunnel clients joining my server rather than sharing my Public IP. 

## Network & Port Forward Configuration
The following ports are configured for external connections:
* **Port 22:** OpenSSH for remote access managemanet.
*  **Port 2566-25567:** To allow external clients to join the Minecraft servers.

The following port is strictly limited to the LAN using (UFW):
* **Port 445:** SMB file sharing for file storage and game server backups
  
## Game Hosting & Automation
### For alternative games:
* **Centralization:** [AMP Instance Manager](https://cubecoders.com/AMP) by CubeCoders is a self-hosted web control panel accessed locally for game servers. Offering a selection of games with premade configurations to deploy game servers quickly in a unified dashboard.
  
* **Containerized Isolation:** Each instance resides its own Docker container for fast provisioning and efficient resource allocation to reduce the amount of dependencies installed on the main system. 

Below is a view of the AMP dashnoard:

<img width="1427" height="830" alt="amp instmgr" src="https://github.com/user-attachments/assets/97ae6dfc-8e70-497e-a0e7-657be14c8921" />

### <img width="25" height="25" alt="Minecraft_Bedrock_2023" src="https://github.com/user-attachments/assets/7a5e97c9-50a2-415a-9681-ceecc3339a34" /> For Minecraft:
* **Directory Control:** Each server is separated in its own directory with different configurations (Worlds, Survival/Creative mode) running on Java `openjdk 25.0.4.1`.
  
* **Rapid Scalability:** Within minutes of editing the script, adding a folder, and updating port-forwarding rules allow me to run as many servers with respect to the server's resources. 

Below is a view of multiple Minecraft servers running:

<img width="1889" height="710" alt="servers" src="https://github.com/user-attachments/assets/20742bf7-53f3-4f28-a26e-aeb8a1bdc836" />

### One-Click Startup
To simplify operations, I researched Bash scripting through guides and forums such as Stack Exchange and Stack Overflow. This eliminated repetitive manual typing in the command line (CLI) to relaunch each server during maintainance or server reboots. (ChatGPT) AI was barely starting to release to the public which helped me polish my script.

With one click of a desktop shortcut the script `launch_servers.sh` sequence handles:
1. Opens CLI terminals respective of how many instances will be running.
2. Checks that an executable jar file is found in its directory.
3. Launch servers and check for server/plugin updates.
4. Resize CLI terminals to fit-to-screen.

## Backup & Recovery
* **Snapshots:** Linux Mint's native backup application **TImeShift** takes monthly incremental snapshots of the OS for system file protection from bad updates and crashes.
  
* **Backup Plugin:** Using server plugins, Minecraft servers are automatically backed up every 30 minutes with a limit of 5 backups per server and stored on a hard drive.
  
* **Redundancy:** Backups are accessible through SMB share allowing me to store copies to multiple locations, ensuring fast availability and recovery.

Below is the configuration for SMB:

<img width="1333" height="697" alt="SMB" src="https://github.com/user-attachments/assets/cfdd7008-8f3e-4f7a-800a-98e9b3abbfaa" />

## Lessons Learned
### Setting up Thinlinc
* **$${\\color{red}Problem:}$$** When connecting from outside my home network, the client would result in "Connection timed out" errors. Connecting internally had no issues.
  
* **$\color{#00FF00}\{Solution:}$** Due to my server running on a private network with Network Address Translation (NAT), the issue was related to the `agent_hostname=` parameter on the vsmagent file left blank by default.
  * Editing the file with **nano** and adding my public IP to `/opt/thinlinc/etc/conf.d/vsmagent.hconf` forces the service to route to the endpoint listening on the forwarded ports.

### Issues with AMP and Docker
* **$${\\color{red}Problem:}$$** During the CLI setup for AMP, Docker was selected to be installed to containerize instances. However, attempting to create new game instances inside Docker containers resulted in "access denied" errors.
  
* **$\color{#00FF00}\{Solution:}$** AMP's built-in system log viewer helped me identify permissions that needed to be changed. The user `amp` needed to be added to the Docker security group using the command `sudo usermod -aG docker amp` to allow administrative controls.

### Why Plasma KDE VS. XFCE
The reason for running Plasma KDE environment over XFCE was due to the fact that KDE's native customization options allow me to add resource usage and monitoring widgets to my desktop/taskbar.

Below is a view of widgets in use:

<img width="558" height="323" alt="image" src="https://github.com/user-attachments/assets/4d901e9a-b789-4a12-9aad-385c7771ac38" />

## Future Improvements
* **Distro Switch:** Eventually, I would like to transition to *Ubuntu *Server, but I find using the desktop environment/CLI combo has been more efficient thus far.
  
*  **RAID:** In the future, I want to have a RAID 5 array for more storage and data protection. Due to AI demand, HDD prices are very expensive at the moment.
