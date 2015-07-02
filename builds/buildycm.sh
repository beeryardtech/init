#!/bin/bash -
###
# @name Init.buildycm
# @param {string} repos
# @description
# Build the VIM plugin YouCompleteMe (ycm).
##
cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Runs the "build" init scripts and checks results.
NOTE that if any script fails exits with that error code
and does not continue.

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dryrun=
optstring=hn
while getopts $optstring opt ; do
    case $opt in
    h) echo $USAGE ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

if [[ -d ~/.vim/bundle/YouCompleteMe ]] ; then
    pushd $HOME/.vim/bundle/YouCompleteMe

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
