#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Build Shrew Soft VPN (iked) from source code

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dryrun=
optstring=hn
while getopts $optstring opt ; do
    case $opt in
    h) echo "$USAGE" ; exit 255 ;;
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
    local arg_file=$2
    local dry=$2

    if [[ $dry ]] ; then
        [[ -d "$repo" ]] && exists=true || exists=false
        [[ -f "$arg_file" ]] && arg_exists=true || arg_exists=false
        echo "Repo: $repo"
        echo "Repo exists: $exists"
        echo "Arg file exists: $arg_exists"
        echo "Cmake args: $(< $arg_file)"
        return
    fi

    cmake $(< $arg_file)
    err=$?
    die $err "Cmake failed! Args: $(< $arg_file)"

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
