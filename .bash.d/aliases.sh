##
# Misc alias
alias bat="batcat"
alias bc='bc -l'
alias c="clear"
alias cp="cp -i"
alias cpProgress="rsync --progress -ravz"
alias fd="fdfind"
# move any untracked files into a 'junk' folder
# This is useful for cleaning up your working directory without deleting files.
alias gj="git ls-files --others --exclude-standard -z | xargs -0 -I {} mv {} junk/"
alias gl="vi -c 'Gclog'" # assumes plugin installed.
alias grep="grep --color=tty -d skip"
alias grep="rg"
alias gs="git status "
alias hd='od -Ax -tx1z -v' # hexdump
alias j=`which autojump`
alias kb="kubectl"
alias lg='lazygit'
alias ltmux="if tmux has; then tmux attach; else tmux new; fi"
alias mv="mv -i"
alias nvimdiff="nvim -d"
alias pc="python -m py_compile "
alias ping="time ping"
alias please='sudo'
alias pyl='PYTHONPATH=. pylint'
alias pyt='PYTHONPATH=. pytest'
alias realpath='readlink -f'
alias rm="rm -i"
alias token='az account get-access-token --query accessToken -o tsv | clip.exe'
alias tui='taskwarrior-tui'
alias t='task'
alias vi="nvim"
vim() {
     nvim $(fzf --multi)
 }
alias vidiff="nvim -d"
alias vimdiff="nvim -d"
alias wget='wget -c'
# YAML alias to parse YAML from stdin
alias yc="python -c 'import yaml, sys; print(yaml.safe_load(sys.stdin))' < "

chat() {
    # Open Neovim with Copilot Chat
    # If an argument is provided, load the specified chat session as context
    # Otherwise, start a new chat session
    if [ $# -eq 0 ]; then
        nvim -c ":CopilotChat" -c ":only" -c ":set number!" -c ":set signcolumn=no"
    else
        nvim -c ":CopilotChatLoad $1" -c ":CopilotChat" -c ":only" -c ":set number!" -c ":set signcolumn=no"
    fi
}

nv() {
    if ss -ln 2>/dev/null | grep -q ":6666 "; then
        echo "NeoVim running on port 6666 - remote to it"
        nvim --server localhost:6666 --remote-silent "$@"
    else
        echo 'Starting NeoVim server on port 6666'
        nvim --listen localhost:6666 "$@"
    fi
}

nvt() {
    if ss -ln 2>/dev/null | grep -q ":6666 "; then
        echo "NeoVim running on port 6666 - remote to it"
        nvim --server localhost:6666 --remote-tab "$@"
    else
        echo 'Starting NeoVim server on port 6666'
        nvim --listen localhost:6666 "$@"
    fi
}

alias nvkill='pkill -f "nvim.*listen.*6666"'
