#!/bin/bash -
###
# @name Init.buildycm
# @param {string} repos
# @description
# Build the VIM plugin YouCompleteMe (ycm).
##
cleanup()
{
    echo "#### Trapped in buildycm.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

if [[ -d ~/.vim/bundle/YouCompleteMe ]] ; then
    pushd $HOME/.vim/bundle/YouCompleteMe

    #echo "*** YCM - Gitting submodule ***"
    #git submodule update --init --recursive

    echo "*** Compiling YCM ***"
    ./install.sh --clang-completer
    error=$?

    echo "YCM done:" $error

     #Try again without clang
    if [[ $error == 1 ]] ; then
        echo "Trying again without clang support"
        ./install.sh
        echo "YCM done:" $?
    fi


    popd
else
    echo "YCM Directory does not exist!"
    echo
fi
