#!/bin/bash -
#===============================================================================
#         USAGE: ./buildycm.sh $repos
#       CREATED: 11/14/2014 20:22
#===============================================================================
###
# @name InitFuncs.buildycm
# @param {string} repos
##
cleanup()
{
    echo "#### Trapped in buildvimdeps.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

if [[ -d ~/.vim/bundle/YouCompleteMe ]] ; then
    pushd $HOME/.vim/bundle/YouCompleteMe
    echo "*** Compiling YCM ***"
    ./install.sh --clang-completer --omnisharp-completer

    popd
else
    echo "YCM Directory does not exist!"
    echo
fi
