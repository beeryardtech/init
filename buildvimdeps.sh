#!/bin/bash -
cleanup()
{
    echo "#### Trapped in buildvimdeps.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get Bundles, install deps
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Build YCM - script should be in same directory
$DIR/buildycm.sh

if [[ -d $HOME/.vim/bundle/tern_for_vim ]] ; then
    pushd $HOME/.vim/bundle/tern_for_vim
    echo "*** Compiling TERN ***"
    if [[ ! -f $HOME/.vim/bundle/tern_for_vim/package.json ]] ; then
        wget https://raw.githubusercontent.com/marijnh/tern_for_vim/master/package.json
    fi
    npm install
    popd
else
    echo "Tern_For_Vim Directory does not exist!"
    echo
    exit 1
fi
