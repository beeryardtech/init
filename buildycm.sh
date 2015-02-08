#!/bin/bash -
#===============================================================================
#         USAGE: ./buildycm.sh $repos
#       CREATED: 11/14/2014 20:22
#===============================================================================
###
# @name Init.buildycm
# @param {string} repos
# @description
# Build the VIM plugin YouCompleteMe (ycm).
##
cleanup()
{
    echo "#### Trapped in buildvimdeps.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

if [[ -d ~/.vim/bundle/YouCompleteMe ]] ; then
    pushd $HOME/.vim/bundle/YouCompleteMe

    #echo "*** YCM - Gitting submodule ***"
    #git submodule update --init --recursive

    echo "*** Compiling YCM ***"
    ./install.sh --clang-completer

    echo "YCM done:" $?

     #Try again without clang
    if [[ $? == 1 ]] ; then
        echo "Trying again without clang support"
        ./install.sh
        echo "YCM done:" $?
    fi


    popd
else
    echo "YCM Directory does not exist!"
    echo
fi
