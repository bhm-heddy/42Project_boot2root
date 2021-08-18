#!/bin/bash

#Run as root ?
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

#SHELL USE
SH=zsh

#Update
apt-get update

#revers shell tools
apt -y install rlwrap
apt -y install pwncat

#autorecon
#https://www.hackingarticles.in/comprehensive-guide-to-autorecon/
apt -y install python3 
apt -y install python3-pip
apt -y install python3-venv
python3 -m pip install --user pipx
python3 -m pipx ensurepath
source ~/.$SHrc
apt -y install seclists curl enum4linux gobuster nbtscan nikto nmap onesixtyone oscanner smbclient smbmap smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf
pipx install git+https://github.com/Tib3rius/AutoRecon.git


#GDB Sexy
echo -e "Install GDB\n->Dashbord (1)\n->Peda     (2)"
read GDB
if [ $GDB -eq  1 ]; then
	wget -P ~ https://git.io/.gdbinit
	pip install pygments
elif [ $GDB -eq 2 ]; then
	git clone https://github.com/longld/peda.git ~/peda
	echo "source ~/peda/peda.py" >> ~/.gdbinit
else
	exit (1)
fi

#Checksec
apt -y install checksec
