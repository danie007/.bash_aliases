#!/bin/bash

sudo apt update

which curl &> /dev/null

if [ #? -ne 0 ]; then
        echo "Installing curl..."
        sudo apt install curl -y

mv ~/.bashrc ~/.bashrc.old
mv ~/.bash_aliases ~/.bash_aliases.old
curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bash_aliases > ~/.bash_aliases
curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bashrc > ~/.bashrc

cd
source .bashrc
sudo su
cp .bashrc .bash_aliases /root/

echo "Setting vm swappiness to 10"
echo -e "# Restricting swappiness\nvm.swappiness=10" >> /etc/sysctl.conf
sysctl -p

# echo "Changing dock position to bottom... (current user only)"
# gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
# gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

exit

sudo apt --full-upgrade -y

sudo shutdown -r +! "System is shutting down in one minute, save your work ASAP!"
