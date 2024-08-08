##
# misc git helpers
gClean () {
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

gblame () {

    local file=$(fzf)

    cat "$file" | \
        awk '{printf("%5d %s\n", NR, $0)}' |\
        fzf --layout reverse --preview-window up --preview "echo {} | awk '{print \$1}' | xargs -I _ sh -c \"git log --color -L_,'+1:${file}'\""
}
