##
# Misc alias
alias bat="batcat"
alias bc='bc -l'
alias c="clear"
alias cp="cp -i"
alias cpProgress="rsync --progress -ravz"
alias fd="fdfind"
# move any untracked files into a 'junk' folder
alias gj="git ls-files --others --exclude-standard -z | xargs -0 -I {} mv {} junk/"
alias gl="vi -c 'Gclog'" # assumes plugin installed.
alias grep="grep --color=tty -d skip"
alias grep="rg"
alias gs="git status "
alias hd='od -Ax -tx1z -v'
alias j=`which autojump`
alias kb="kubectl"
alias lg='lazygit'
alias ltmux="if tmux has; then tmux attach; else tmux new; fi"
alias mv="mv -i"
alias nvimdiff="nvim -d"
alias nvremote='nvim --headless --listen localhost:6666'
alias pc="python -m py_compile "
alias ping="time ping"
alias please='sudo'
alias pyl='PYTHONPATH=. pylint'
alias pyt='PYTHONPATH=. pytest'
alias realpath='readlink -f'
alias rm="rm -i"
alias token='az account get-access-token --query accessToken -o tsv | clip.exe'
alias vi="nvim"
vim() {
     nvim $(fzf --multi)
 }
alias vidiff="nvim -d"
alias vimdiff="nvim -d"
alias wget='wget -c'
alias yc="python -c 'import yaml, sys; print(yaml.safe_load(sys.stdin))' < "
