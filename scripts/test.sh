#!/usr/bin/bash
 latest_chat() {
     directory="/tmp/chat_cache"
     shopt -s nullglob
     files=("$directory"/*)
     latest="/dev/null"
     latest_timestamp=0
     for file in "${files[@]}"; do
         if [[ $file =~ ^$directory/[0-9]+$ && $(stat -c %Y $file) -gt $(stat -c %Y $latest) ]]; then
             latest=$file

         fi
     done

	 echo $(basename $latest)
 }

gr () {
    case $1 in
        last)
            token=$(latest_chat)
            echo ~/venvs/shellgpt/bin/sgpt ${gptRoll} --repl "${token}"
            ;;
        "")
            echo 'Nothing passed in, new shellgpt @:'
            token=$(latest_chat)
            ((token++))
            echo ~/venvs/shellgpt/bin/sgpt ${gptRoll} --repl "${token}"
            ;;
        *)
            echo ~/venvs/shellgpt/bin/sgpt ${gptRoll} --repl "${1}"
            ;;
    esac
}
gr poop
