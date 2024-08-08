# better directory changing. 
# overwrites cd inline
#   https://github.com/ajeetdsouza/zoxide
if command -v zoxide &> /dev/null
then
    eval "$(zoxide init bash --cmd cd)"
fi
