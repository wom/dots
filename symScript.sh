#!/bin/bash

echo "Symlinking  dot files..."
cd 
dotList='.bashrc .tmux.conf .screenrc .vimrc .config/starship.toml'
dotFold="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "dotFold: ${dotFold}";
mkdir -p ~/.config
for dotFile in $dotList; do
    if [ -f ${dotFile} ]; then
	echo "${dotfile} exists; backing up..";
	mv ${dotFile}{,.orig};
    fi
    echo "Linking ${dotFold}/${dotFile}...";
    ln -s ${dotFold}/${dotFile} ${dotFile}
done
