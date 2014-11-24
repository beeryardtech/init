#!/bin/bash -
cleanup()
{
    echo "#### Trapped in buildvimdeps.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

# Get Bundles, install deps
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle.git
vim +PluginInstall +qall

if [[ -d ~/.vim/bundle/YouCompleteMe ]] ; then
    pushd $HOME/.vim/bundle/YouCompleteMe

    echo "*** YCM - Gitting submodule ***"
    git submodule update --init --recursive

    echo "*** Compiling YCM ***"
    install.sh --clang-completer --omnisharp-completer

    popd
else
    echo "YCM Directory does not exist!"
    echo
    exit 1
fi

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
