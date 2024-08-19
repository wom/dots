#HSTR configuration
export HSTR_CONFIG=hicolor,raw-history-view # get more colors
shopt -s histappend                         # append new history items to .bash_history
export HISTCONTROL=ignorespace              # leading space hides commands from history
export HISTFILESIZE=10000                   # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}             # increase history size (default is 500)
if command -v mcfly &> /dev/null; then
    export MCFLY_LIGHT=FALSE
    export MCFLY_KEY_SCHEME=vim
    export MCFLY_RESULTS=50
    export MCFLY_DISABLE_MENU=TRUE
    export MCFLY_PROMPT="→"
    eval "$(mcfly init bash)"
elif command -v hstr &> /dev/null; then
    # if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
    if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
    # if this is interactive shell, then bind 'kill last command' to Ctrl-x k
    if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
    # ensure synchronization between bash memory and history file - buggy
    # export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
fi
