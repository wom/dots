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

# if dbus is not running start it
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    dbus-run-session -- bash
fi
# carapace! Experimental
# ~/.bashrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
source <(carapace _carapace)
# Only run if DBUS is running and gnome-keyring-daemon is not
# if [ -n "$DBUS_SESSION_BUS_ADDRESS" ] && [ -z "$SSH_AUTH_SOCK" ]; then
#     # Prompt the user for the keyring password
#     read -s -p "Enter keyring password: " keyring_password
#     echo
#     # Unlock the gnome-keyring-daemon with the provided password
#     export $(echo -n "$keyring_password" | gnome-keyring-daemon --unlock)
# fi

if command -v keychain &> /dev/null
then
    eval `keychain --eval --agents ssh id_rsa`
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
export PATH="~/venvs/poetry/bin/:~/venvs/misctools/.venv/bin/:~/.poetry/bin/:~/scripts:~/bin/:/usr/local/bin:/usr/local/go/bin/:$PATH"
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

alias lg='lazygit'



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
alias fd="fdfind"
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
alias gs="git status "
# move any untracked files into a 'junk' folder
alias gj="git ls-files --others --exclude-standard -z | xargs -0 -I {} mv {} junk/"
gClean() {
    # move any untracked files into a 'junk' folder
    junk_dir="junk"
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        if [ "$(pwd)" != "$(git rev-parse --show-toplevel)" ]; then
            echo "Not in the root of a git repository."
            return 1
        fi
        mkdir -p "$junk_dir"
        untracked_files=$(git ls-files --others --exclude-standard -- ':!junk/*')
        if [ -n "$untracked_files" ]; then
            mv $untracked_files "$junk_dir"/. && echo "Files cleaned successfully!"
        else
            echo "Clean!"
        fi
    else
        echo "Not at top level of a git repository."
    fi
}
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
function wsl() {
    sudo bash <<"EOF"
ip link set dev eth0 mtu 1400
hwclock -s
EOF
}


if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
fix_line_endings()
{
    set -x
    tmpFile=$(mktemp)
    cp ${1}{,.badle}
    tr -d '\15\32' < "${1}" > "${tmpFile}"
    mv -f "${tmpFile}" "${1}"
    set +x
}
paste()
{
    # inside WSL - Paste from Windows clipboard.
    # $ echo 'hi!' | clip.exe
    # $ paste > /tmp/whyhellothere
    powershell.exe Get-Clipboard | sed 's/\r//'
}
_sgpt_bash() {
    if [[ -n "$READLINE_LINE" ]]; then
        READLINE_LINE=$(sgpt --shell --no-interaction <<< "$READLINE_LINE")
        READLINE_POINT=${#READLINE_LINE}
    fi
}
_sgpt_describe_bash() {
    if [[ -n "$READLINE_LINE" ]]; then
        CMD="$READLINE_LINE"
        local OUTPUT=$(sgpt --describe-shell <<< "$CMD")
        #echo -e "\n${CMD}\n\n${OUTPUT}"
        printf "\n${CMD}\n\n${OUTPUT}"

    fi
}

# require the user to have shellgpt installed (easiest in a venv) and OPENAI_API_KEY set in environment.
# Shell-GPT integration BASH v0.1
# ctrl-l to turn plain text prompt into a unix command.
bind -x '"\C-l": _sgpt_bash'
bind -x '"\C-k": _sgpt_describe_bash'
alias sgpt='~/venvs/shellgpt/bin/sgpt'
export gptRoll=""
alias g="~/venvs/shellgpt/bin/sgpt ${gptRoll}"
# # short function to spin up a shellgpt repl quickly; or let me connect to an existng.
latest_chat() {
    directory="/tmp/chat_cache"
   latest=$(find /tmp/chat_cache/ -type f -regex '.*/[0-9]+$' -printf '%T@ %f\n' | sort -nr | head -n 1 | cut -d' ' -f2)
    echo $(basename $latest)
}

gr () {
    mkdir -p /tmp/chat_cache/
    case $1 in
        last)
            token=$(find /tmp/chat_cache/ -type f -printf '%T@ %f\n' | sort -nr | head -n 1 | cut -d' ' -f2)
            ~/venvs/shellgpt/bin/sgpt ${gptRoll} --repl "${token}"
            ;;
        "")
            # give me n+1 latest 
            token=$(find /tmp/chat_cache/ -maxdepth 1 -type f -regextype egrep -regex '.*/[0-9]+$' | grep -o '[0-9]\+$' | sort -n | tail -n 1 | awk '{print ($0+1)}')
            token=${token:-1}
            echo "gpt: $token"
            ~/venvs/shellgpt/bin/sgpt ${gptRoll} --repl "${token}"
            ;;
        *)
            ~/venvs/shellgpt/bin/sgpt ${gptRoll} --repl "${1}"
            ;;
    esac
}

function frd {
    # fuzzy search via ripgrep and fzf - then open in editor on selection
    result=`fd --ignore-case --color=always  "$@" |
        fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "/usr/bin/batcat --color=always {1} --theme='Solarized (dark)' --highlight-line {2}" \
        --preview-window 'up,62%,border-bottom,+{2}+3/3,~3'`
            file="${result%%:*}"
            linenumber=`echo "${result}" | cut -d: -f2`
            if [ ! -z "$file" ]; then
                if [ "$TERM_PROGRAM" == "vscode" ]; then
                    code -g "${file}:${linenumber}"
                else
                    $EDITOR +"${linenumber}" "$file"
                fi
            fi
        }
function frg {
    # fuzzy search via ripgrep and fzf - then open in editor on selection
    result=`rg --ignore-case --color=always --line-number --no-heading "$@" |
        fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "/usr/bin/batcat --color=always {1} --theme='Solarized (dark)' --highlight-line {2}" \
        --preview-window 'up,62%,border-bottom,+{2}+3/3,~3'`
            file="${result%%:*}"
            linenumber=`echo "${result}" | cut -d: -f2`
            if [ ! -z "$file" ]; then
                if [ "$TERM_PROGRAM" == "vscode" ]; then
                    code -g "${file}:${linenumber}"
                else
                    $EDITOR +"${linenumber}" "$file"
                fi
            fi
        }

gblame () {

    local file=$(fzf)

    cat "$file" | \
        awk '{printf("%5d %s\n", NR, $0)}' |\
        fzf --layout reverse --preview-window up --preview "echo {} | awk '{print \$1}' | xargs -I _ sh -c \"git log --color -L_,'+1:${file}'\""

}
if command -v zoxide &> /dev/null
then
    eval "$(zoxide init bash)"
    alias cd='z'
fi

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr                    # hh to be alias for hstr
export HSTR_CONFIG=hicolor       # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
# ensure synchronization between bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
