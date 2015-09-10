#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Fetch source code and build Shrew Soft VPN (iked)

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

##
# Values
##
REPOS="~/repos/ike"

build_ike()
{
    local repo=$1
    local dry=$2
    local cmake_args="-DDEBUG=YES -DQTGUI=YES -DNATT=YES -DLDAP=YES"

    if [[ $dry ]] ; then
        echo "Repo: $repo"
        echo "Cmake args: $args"
        return
    fi

    cmake $cmake_args
    err=$?
    die $err "Cmake failed! Args: $cmake_args"

    make
    err=$?
    die $err "make failed!"

    sudo make install
    err=$?
    die $err "Make Install failed!"
}

main()
{
    pushd $REPOS
    build_ike $REPOS $dryrun
    popd
}
