# User specific aliases and functions
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

unamestr=`uname`
# Tossing azcli venv *first*
export GOPATH="/usr/bin/go"
export GOROOT="/usr/lib/go-1.18"
export PATH="~/scripts:~/.local/bin:~/bin/:/usr/local/bin:/usr/local/go/bin/:$PATH"
while IFS= read -r -d '' dir; do
    # add anything in ~/venvs/*/bin/ to path
    PATH="$dir:$PATH"
done < <(fdfind -t d -d 2 -0 bin ~/venvs)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# if dbus is not running start it
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    dbus-run-session -- bash
fi


if command -v keychain &> /dev/null
then
    eval `keychain --eval --agents ssh id_rsa`
fi


if [[ -d ~/.bash.d ]]; then
    for i in ~/.bash.d/*; do
        if [[ -r "$i" ]]; then
            . "$i"
        fi
    done
    unset i
fi

# #####
# # misc exports.
export EDITOR=nvim
# # Bat theme
export BAT_THEME='Solarized (dark)'

# #custom ssh aliases..
#
source ~/custCon.sh
# # Bat theme
export BAT_THEME='Solarized (dark)'


. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
