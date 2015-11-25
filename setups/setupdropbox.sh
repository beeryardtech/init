#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Installs Dropbox and setups up exlude list

optional arguments:
-e    Apply the normal exclude list
-h    Print this help and exit
-i    Get and run the dropbox installer
-n    Test run
-p    Apply the portable exclude list

EOF

##
# Values
##
SCRIPT="$HOME/.dropbox-dist/dropboxd"
NORM_EXCLUDE=${CURRENT_DIR}/../files/dropbox_norm_exclude.txt
PORTABLE_EXCLUDE=${CURRENT_DIR}/../files/dropbox_portable_exclude.txt
REPO="~/repos/dropbox"
URL="https://www.dropbox.com/download?plat=lnx.x86_64"

is_exclude=
is_install=
dryrun=
list_file=
optstring=ehinp
while getopts $optstring opt ; do
    case $opt in
    e) is_exclude=true ; list_file="$NORM_EXCLUDE" ;;
    h) echo -e "$USAGE" ; exit 255 ;;
    i) is_install=true ;;
    n) dryrun=true ;;
    p) is_exclude=true ; list_file="$PORTABLE_EXCLUDE" ;;
    esac
done

do_exclude()
{
    local path=$1
    local dry=$2

    if [[ $dry ]] ; then
        echo "Exclude path: $path, list: $(< $path )"
        return
    fi

    dropbox exclude add $(< $path )
}

get_dropbox()
{
    local url=$1
    local repo=$2
    local dry=$3

    if [[ $dry ]] ; then
        echo "Url: $url"
        return
    fi

    ${CURRENT_DIR}/../helpers/gettar.sh "$url" "$repo"
    err=$?
    die $err "Failed to get dropbox tar file"
}

do_install()
{
    local cmd=$1
    local dry=$2

    if [[ $dry ]] ; then
        echo "Command: $cmd"
        return
    fi

    ${cmd}
    err=$?
    die $err "Failed to start dropboxd"
}

check_dropbox()
{
    local script="$1"

    if [[ ! -f "$script" ]] ; then
        die 1 "Deamon script does not exist! $script"
    elif [[ ! -x "$script" ]] ; then
        die 1 "Deamon script is not executable! script: $script"
    fi

    local status=$( dropbox status )
    err=$?
    die $err "Dropbox is not running! Status: $status"
}

main()
{
    if [[ $is_install ]] ; then
        get_dropbox "$URL" "$REPO" $dryrun
        do_install $SCRIPT $dryrun
    fi

    if [[ $is_exclude ]] ; then
        check_dropbox "$SCRIPT"
        do_exclude "$list_file" $dryrun
    fi
}
main
