# bash prompt!
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
