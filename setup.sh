#!/bin/bash

ES_SUCCESS=0
ES_PERM_ERR=1

test_site=google.com

# Check for root previlages
if [[ $EUID -ne 0 ]]; then
    echo "run the ${!#} as root"
    exit $ES_PERM_ERR
fi

# function to automatically detect the user and environment of a current session
function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "\(${_display_id}\)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

# Getting the static hostname of runtime
S_HOSTNAME=$(hostnamectl | grep -i "operating system" | cut -d' ' -f5)

# Check for internet connection before proceeding with internet based commands
if ping -q -c 1 -W 1 $test_site > /dev/null; then

    apt update

    # Checking for curl
    which curl &> /dev/null
    if [ $? -ne 0 ]; then
        echo "Installing curl..."
        apt install curl -y
    fi

    curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bash_aliases > ~/.bash_aliases
    curl https://raw.githubusercontent.com/danie007/.bash_aliases/master/.bashrc > ~/.bashrc

    if [ "$S_HOSTNAME" = "Kali" ]; then
        cat << EOT >> ~/.bash_aliases
        
# For Kali Linux 2020

# ifconfig
alias ifconf='sudo ifconfig'

# msfconsole & initialization
alias msfcon='sudo service postgresql start && sudo msfdb init && msfconsole'

# dmesg
alias dmsg='sudo dmesg'
EOT
    fi

    if [ -d "/home/$(logname)" ]; then
        cp ~/.bash_aliases ~/.bashrc /home/$(logname)/ 2> /dev/null
        chown $(logname): /home/$(logname)/.bash_aliases 2> /dev/null
        chown $(logname): /home/$(logname)/.bashrc 2> /dev/null
    fi

    # Installing basic utilities
    echo "Installing basic utilities"
    apt install -y vim make gcc build-essential git net-tools

    if [ "$S_HOSTNAME" = "Ubuntu" ]; then
        # Checking for VS Code
        which code &> /dev/null
        if [ $? -ne 0 ]; then
            # Installing visual studio code
            echo "Installing visual studio code"
            snap install --classic code    # Snap is pre-installed from Ubuntu 16.04
        else
            # Updating visual studio code
            echo "Updating visual studio code"
            snap refresh --classic code
        fi

        # Checking for google chrome
        which google-chrome &> /dev/null
        if [ $? -ne 0 ]; then
            echo "Installing google chrome"
            curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /tmp/chrome_stable.deb

            apt install /tmp/./chrome_stable.deb
        fi

        # Setting favorite apps
        run-in-user-session dconf write /org/gnome/shell/favorite-apps "['google-chrome.desktop', 'gnome-calculator.desktop', 'gnome-calculator_gnome-calculator.desktop', 'org.gnome.Terminal.desktop', 'code_code.desktop', 'org.gnome.Nautilus.desktop']"
    fi

    apt full-upgrade -y
    apt autoremove -y
else
    echo ""
	echo "  No network connection available!"
    echo "  Functionalities will be reduced."
    echo ""
fi

cd

if [ "$S_HOSTNAME" = "Ubuntu" ]; then
    echo "Changing dock position to bottom... (current user: $(sudo -u $SUDO_USER whoami) only)"
    run-in-user-session gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
    run-in-user-session gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
    run-in-user-session gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 12
fi

echo "Setting vm swappiness to 10"

# backing up original configuration
cp /etc/sysctl.conf /etc/sysctl.conf.orig

# Removing old swappiness, if any and rewritng the file
grep -v "vm.swappiness" /etc/sysctl.conf.orig > /etc/sysctl.conf
echo "vm.swappiness=10   # Restricting swap to 10%" >> /etc/sysctl.conf
sysctl -p

shutdown -r +1 "System will restart in 1 minute, save your work ASAP"

exit $ES_SUCCESS