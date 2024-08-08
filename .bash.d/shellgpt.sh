
##
# shell-gpt integrations
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
#/shellgpt
##
