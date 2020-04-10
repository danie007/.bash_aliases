# .bash_aliases
# Created by Daniel
# File to add aliases
# Run "source ~/.bashrc" or reboot after editing

# Repo updates
alias aptupdate='sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove'
alias update='sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y autoremove'

# cd alias
alias ..='cd ..'

# some ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias li='ls -aliCF'

# Clear terminal
alias c='clear'

# shutdown
alias sd='echo Goodbye! && sudo shutdown -h now'

# For Kali Linux 2020

# # ifconfig
# alias ifconf='sudo ifconfig'

# # msfconsole & initialization
# alias msfcon='sudo service postgresql start && sudo msfdb init && msfconsole'
