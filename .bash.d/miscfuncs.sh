## 
# Random Misc functions

##
# Quick conversions
epoc ()
{
    perl -e "print scalar(localtime($1))"
    echo ""
}
#cd ../ aliases
dotSlash=""
for i in 1 2 3 4
do
    dotSlash=${dotSlash}'../';
    baseName=".${i}"
    alias $baseName="cd ${dotSlash}"
done

# mtu - helfpul inside WSL2
alias mtu='sudo ip link set dev eth0 mtu 1400'
function wsl() {
    sudo bash <<"EOF"
ip link set dev eth0 mtu 1400
hwclock -s
EOF
}

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
    # ToDo: make this work on osx/linux
    # $ echo 'hi!' | clip.exe
    # $ paste > /tmp/whyhellothere
    powershell.exe Get-Clipboard | sed 's/\r//'
}
function frd {
    # fuzzy file search via fdfind and fzf - then open in editor on selection
    result=`fdfind --ignore-case --color=always  "$@" |
        fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "/usr/bin/batcat --color=always {1} --theme='Solarized (dark)' --highlight-line {2}" \
        --preview-window 'up,62%,border-bottom,+{2}+3/3,~3'`
            file="${result%%:*}"
            if [ ! -z "$file" ]; then
                if [ "$TERM_PROGRAM" == "vscode" ]; then
                    code -g "${file}:${linenumber}"
                else
                    $EDITOR + "$file"
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

