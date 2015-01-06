# .bashrc
# User specific aliases and functions
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

unamestr=`uname`

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/scripts/git-completion.bash ]; then
    . ~/scripts/git-completion.bash
fi

USER=`whoami`
export PATH="/usr/local/bin:$PATH:/Users/${USER}/scripts"
#save history from all terminals.
shopt -s histappend
PROMPT_COMMAND='history -a'

##
#vi as cl editor. Experiment.
#set -o vi
#set editing-mode vi
#set keymap vi
#set convert-meta on
##


#####
# build prompt.
bash_prompt_command()
{
    RTN=$?
    prevCmd=$(prevCmd $RTN)
}
PROMPT_COMMAND=bash_prompt_command
prevCmd()
{
    if [ $1 == 0 ] ; then
        echo $GREEN
    else
        echo $RED
    fi
}

if [ $(tput colors) -gt 0 ] ; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    RST=$(tput op)
fi
export PS1="\[\e[36m\]\u.\h.\W\[\e[0m\]\[\$prevCmd\]>\[$RST\]"
# end build prompt.
#####


#####
# misc exports.
export EDITOR=vim
#color man pages.
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export P4DIFF='vim-7.2 -d'
#####
# Misc alias
alias cpProgress="rsync --progress -ravz"
alias ping="time ping"
alias c="clear"
alias please='sudo'
##
#Why doesn't this work?
#alias vimdiff="vim-7.3diff"
##
alias g="gvim --remote-silent"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias grep="grep --color=tty -d skip"
alias hd='od -Ax -tx1z -v'
alias realpath='readlink -f'
#alias ns="screen -S `date +'%a_%m_%d_%Y'`"
#alias as="screen -r `screen -list | grep -v 'Socket\|screens on' | grep Detached | awk '{print $1}'`"
alias bc='bc -l'
alias wget='wget -c'
alias ltmux="if tmux has; then tmux attach; else tmux new; fi"
#cd ../ aliases
dotSlash=""
for i in 1 2 3 4
do 
    dotSlash=${dotSlash}'../';
    baseName=".${i}"
    alias $baseName="cd ${dotSlash}"
done



    

#custom ssh aliases..
source ~/custCon.sh


##

##
#todo.sh wrapper
t() { 
    if [ $# -eq 0 ]; then
        ~/scripts/todo.txt_cli-2.9/todo.sh -d ~/.todo/config ls
    else
        ~/scripts/todo.txt_cli-2.9/todo.sh  -d ~/.todo/config $* 
    fi
}
##
#
epoc ()
{
    perl -e "print scalar(localtime($1))"
    echo ""
}

##
#current weather.
weather ()
{
    declare -a WEATHERARRAY
    zip="15202"
    WEATHERARRAY=( `lynx -dump "http://www.google.com/search?hl=en&lr=&client=firefox-a&rls=org.mozilla%3Aen-US%3Aofficial&q=weather+${zip}&btnG=Search" | grep -A 5 -m 1 "Weather for" |  sed "s/ - \[.*iGoogle/ - /"`)
    echo ${WEATHERARRAY[@]}
}

##
#Screen..
#if [ "$SSH_CONNECTION" ]; then
#    if [ -z "$STY" ]; then
#        # Screen is not currently running, but we are in SSH, so start a session
#        exec screen -d -R
#    fi
#fi
##

if [[ "$unamestr" == 'Darwin' ]]; then
#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
    [[ -s "/Users/${USER}/.gvm/bin/gvm-init.sh" ]] && source "/Users/${USER}/.gvm/bin/gvm-init.sh"
fi 
