#!/bin/bash

ES_SUCCESS=0
ES_NOPERM=1

if [[ $EUID -ne 0 ]]; then
    echo "run the ${!#} as root"
    exit $ES_NOPERM
fi

apt update

which curl &> /dev/null

if [ $? -ne 0 ]; then
    echo "Installing curl..."
    apt install curl -y
fi

curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bash_aliases > ~/.bash_aliases
curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bashrc > ~/.bashrc

if [ -d "/home/$(logname)" ]; then
    cp ~/.bash_aliases ~/.bashrc /home/$(logname)/ 2> /dev/null
    chown $(logname): /home/$(logname)/.bash_aliases 2> /dev/null
    chown $(logname): /home/$(logname)/.bashrc 2> /dev/null
fi

cd
source .bashrc

echo "Setting vm swappiness to 10"

# basking up original configuration
cp /etc/sysctl.conf /etc/sysctl.conf.orig

# Removing old swappiness, if any and rewritng the file
grep -v "vm.swappiness" /etc/sysctl.conf > /etc/sysctl.conf 2> /dev/null
echo -e "# Restricting swappiness\nvm.swappiness=10" >> /etc/sysctl.conf
sysctl -p

# echo "Changing dock position to bottom... (current user only)"
# gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
# gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

apt --full-upgrade -y

shutdown -r +1 "System is shutting down in one minute, save your work ASAP"

exit $ES_SUCCESS
