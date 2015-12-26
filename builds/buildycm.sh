#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Build the VIM plugin YouCompleteMe (ycm).

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dryrun=
optstring=hn
while getopts $optstring opt ; do
    case $opt in
    h) echo -e "$USAGE" ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

##
# Values
##
REPO="$HOME/.vim/bundle/YouCompleteMe"

check_ycm()
{
    local repo="$1"
    local script="${repo}/install.py"

    if [[ ! -d "$repo" ]] ; then
        die 1 "YCM repo does not exist! Dir: $repo"
    elif [[ ! -f "$script" ]] ; then
        die 1 "Install script does not exist! script: $script"
    elif [[ ! -x "$script" ]] ; then
        die 1 "Install script is not executable! script: $script"
    fi

    echo "YCM check is successful"
}

build_ycm()
{
    local dry=$1
    local args="--clang-completer"

    if [[ $dry ]] ; then
        echo "Args: $args"
        return
    fi

    ./install.py "$args"
    err=$?
    die $err "YCM install script failed! Args: $args"
}

main()
{
    check_ycm $REPO

    pushd $REPO
    build_ycm $dryrun
    popd
}
main
