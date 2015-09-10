#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Fetch and install external deb packages.

- Download deb with wget
- install with dpkg
- Resolve dependences with `apt-get install -f`

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

do_get()
{
    local path=$1
    local url=$2
    local dry=$3

    if [[ $dry ]] ; then
        echo "Path to deb file: $path"
        return
    fi

    wget -O "$path" "$url"
    err=$?
    die $err "Failed to install! Path: $path"

}

do_install()
{
    local path=$1
    local dry=$2

    if [[ $dry ]] ; then
        echo "Path to deb file: $path"
        return
    fi

    sudo dpkg -i $path
    err=$?
    die $err "Failed to install! Path: $path"
}

do_resolve()
{
    local dry=$1
    local assume="--assume-yes"

    if [[ $dry ]] ; then
        echo "Try to resolve the following"
        echo
        assume="--assume-no"
    fi

    sudo apt-get install ${assume} -f
    err=$?
    die $err "Failed to resolve dependences!"
}

main()
{
    local url=$1
    local path=$( get_path_from_url $url )

    do_get $path $url $dryrun
    do_install $path $dryrun
    do_resolve $dryrun
}
main $@
