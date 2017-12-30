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

##
# https://github.com/wting/autojump || \
# brew install autojump
if [[ "$unamestr" == 'Darwin' ]]; then
    [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
elif [ -f ~/.autojump/etc/profile.d/autojump.sh ]; then
    . ~/.autojump/etc/profile.d/autojump.sh
fi

USER=`whoami`
export PATH="/usr/local/bin:$PATH:~/scripts:~/bin/"
#save history from all terminals.
shopt -s histappend
PROMPT_COMMAND='history -a'

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
case $- in
*i*)    # interactive shell
	if [ $(tput colors) -gt 0 ] ; then
		RED=$(tput setaf 1)
		GREEN=$(tput setaf 2)
		RST=$(tput op)
	fi
	export PS1="\[\e[36m\]\u.\h.\W\[\e[0m\]\[\$prevCmd\]>\[$RST\]"
    ;;
*)      # non-interactive shell
    ;;
esac
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
alias j=`which autojump`

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
alias bc='bc -l'
alias wget='wget -c'
alias ltmux="if tmux has; then tmux attach; else tmux new; fi"
##
#alias startJenk='sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist'
#alias stopJenk='sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist'
##

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

##virtualenv lazy loading if exists...
if hash virtualenvwrapper_lazy.sh 2>/dev/null; then
    source `which virtualenvwrapper_lazy.sh`
fi


##

##
# Quick conversions 
epoc ()
{
    perl -e "print scalar(localtime($1))"
    echo ""
}
