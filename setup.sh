!/bin/bash

ES_SUCCESS=0
ES_NOPERM=1

if [[ "${USER}" != "root" ]]; then
    echo "run the ${!#} as root"
    exit $ES_NOPERM
fi

apt update

which curl &>/dev/null

if [ $? -ne 0 ]; then
    echo "Installing curl..."
    apt install curl -y
fi
mv ~/.bashrc ~/.bashrc.old
mv ~/.bash_aliases ~/.bash_aliases.old
curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bash_aliases >~/.bash_aliases
curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bashrc >~/.bashrc

cd
source .bashrc
su
cp .bashrc .bash_aliases /root/

echo "Setting vm swappiness to 10"
echo -e "# Restricting swappiness\nvm.swappiness=10" >>/etc/sysctl.conf
sysctl -p

# echo "Changing dock position to bottom... (current user only)"
# gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
# gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true

exit

apt --full-upgrade -y

shutdown -r +1 "System is shutting down in one minute, save your work ASAP"

exit $ES_SUCCESS
