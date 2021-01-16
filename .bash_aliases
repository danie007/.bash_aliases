# .bash_aliases
# -rw-r--r-- 1 usr usr 589 Apr 10 10:54 .bash_aliases
# Created by Daniel
# File to add aliases
# Run "source ~/.bashrc" or reboot after editing

# Alias definitions from .bashrc.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# if [ -f ~/.bash_aliases ]; then
#     . ~/.bash_aliases
# fi

# Repo updates
alias aptupdate='sudo apt update && sudo apt -y upgrade; sudo apt -y autoremove'
alias update='sudo apt-get update && sudo apt-get -y upgrade; sudo apt-get -y autoremove; sudo snap refresh'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Add an "alarm" alias for long running commands.
# Provides audible feedback after the process ends (Repeats for 5 times)
# Usage: sleep 10; alarm
alias alarm='for i in {1..5}; do aplay /usr/share/sounds/buzzer.wav &> /dev/null; sleep 39; done'

# cd alias
alias ..='cd ..'

# some ls aliases
alias ll='ls -alF'
alias lh='ls -halF' # Long listing with human readable size values
alias la='ls -A'
alias l='ls -CF'
alias li='ls -aliF'

# sudo aliases
alias _='sudo'
alias _i='sudo -i'
alias please='sudo'

# Clear terminal
alias c='clear'

# shutdown
alias sd='echo Goodbye! && sudo shutdown -h now'

# Return status of last command
alias ret='echo $?'

# git styling guide
alias format='echo -e "\nGit status:\n\e[1;37mWhite\e[0m - clean\n\e[1;32mGreen\e[0m - changes are staged\n\e[1;31mRed\e[0m - uncommitted changes with nothing staged\n\e[1;33mYellow\e[0m - both staged and unstaged changes\n+ changes are staged and ready to commit\n! unstaged changes\n? untracked files\nS changes have been stashed\nP local commits need to be pushed to the remote\n"'

# Screen with logging
# Usage: scrn USB_no Logfile_location
alias scrn='function _ser(){ sudo screen -S ser -L -Logfile /home/ux/$2 /dev/ttyUSB$1 115200; sudo screen -S ser -X colon "logfile flush 0^M"; };_ser'
