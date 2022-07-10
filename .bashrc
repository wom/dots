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
if [ -f /usr/local/etc/bash_completion.d/poetry.bash-completion ]; then
    /usr/local/etc/bash_completion.d/poetry.bash-completion
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
# Tossing azcli venv *first*
export PATH="~/venvs/azclivenv/bin/:~/venvs/misctools/.venv/bin/:~/.poetry/bin/:~/scripts:~/bin/:/usr/local/bin:$PATH"
#save history from all terminals.
shopt -s histappend
# If we have Starship - Use it! else use our custom bash prompt
if command -v starship &> /dev/null
then
    eval "$(starship init bash)"
else
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
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }
    case $- in
    *i*)    # interactive shell
        if [ $(tput colors) -gt 0 ] ; then
            RED=$(tput setaf 1)
            GREEN=$(tput setaf 2)
            RST=$(tput op)
        fi
        export PS1="\[\e[36m\]\u.\h.\W\[\e[0m\]\$(parse_git_branch)\[\033[00m\]\[\$prevCmd\]>\[$RST\]"
        ;;
    *)      # non-interactive shell
        ;;
    esac
    fi
# end build prompt.
#####

# This doesn't work for me?
if command -v keychain &> /dev/null
then
    eval `keychain --eval --agents ssh id_rsa`
    #keychain -q --eval id_rsa
    #keychain --eval --agents ssh id_rsa
    #eval `keychain -q --eval id_rsa`
    #eval `keychain --eval --agents ssh id_rsa`
    #/usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa
    #source $HOME/.keychain/$HOSTNAME-sh
fi

#####
# misc exports.
export EDITOR=nvim
export MANPAGER='nvim --clean +Man!'
#color man pages.
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
# Bat theme
export BAT_THEME='Solarized (dark)'
#####
# Misc alias
alias cpProgress="rsync --progress -ravz"
alias ping="time ping"
alias c="clear"
alias please='sudo'
alias j=`which autojump`
alias pyl='PYTHONPATH=. pylint'
alias pyt='PYTHONPATH=. pytest'

##
alias vimdiff="nvim -d"
alias vidiff="nvim -d"
alias nvimdiff="nvim -d"
alias nvremote='nvim --headless --listen localhost:6666'
# assumes plugin installed.
alias gl="vi -c 'Gclog'"
##
alias vi="nvim"
alias grep="rg"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias bat="batcat"
alias grep="grep --color=tty -d skip"
alias hd='od -Ax -tx1z -v'
alias realpath='readlink -f'
alias bc='bc -l'
alias wget='wget -c'
alias ltmux="if tmux has; then tmux attach; else tmux new; fi"
alias pc="python -m py_compile "
alias yc="python -c 'import yaml, sys; print(yaml.safe_load(sys.stdin))' < "
#alias az="/usr/local/bin/az"
alias kb="kubectl"
# For this to work, setup system wide kube completions.
# kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
complete  -F __start_kubectl kb # get shell completion
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
function change-ns() {
    namespace=$1
    if [ -z $namespace ]; then
        echo "Please provide the namespace name: 'change-ns mywebapp'"
        return 1
    fi

    kubectl config set-context $(kubectl config current-context) --namespace $namespace
}

# allow single agent to work across all sessions
#export SSH_AUTH_SOCK='~/.ssh/ssh-agent.sock'
#auth ()
#{
    ## startup ssh-agent if not already running; and auth key.
    #RESULT=`pgrep ssh-agent`
    #if [ "${RESULT:-null}" == "null" ]; then
        #echo "${PROCESS} not running, starting "$PROCANDARGS
        #echo 'Starting Agent'
        #eval $(ssh-agent -s -a "${SSH_AUTH_SOCK}")
    #fi
    #ssh-add
#}
auth ()
{
    eval $(ssh-agent -s)
    ssh-add
}

# mtu?
alias mtu='sudo ip link set dev eth0 mtu 1400'


# HSTR configuration 
alias hh=hstr                                     # hh to be alias for hstr
export HSTR_CONFIG=hicolor,raw-history-view       # get more colors and default to History view.
shopt -s histappend                               # append new history items to .bash_history
export HISTCONTROL=ignorespace                    # leading space hides commands from history
export HISTFILESIZE=10000                         # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}                   # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

. "$HOME/.cargo/env"
