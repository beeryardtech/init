#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Gets any external python libraries.

Use `get_libs()` for all required dependences.
and then run `get_single_lib()` for each following lib.

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

###
# Values
###
INSTALLS="$CURRENT_DIR/../files/pip_installs.txt"
REMOVES="$CURRENT_DIR/../files/pip_removes.txt"

get_libs()
{
    local installs=$1
    local dry=$2

    if [[ $dry ]] ; then
        [[ -f "$installs" ]] && exists=true || exists=false
        echo "Installs exists: $exists"
        echo "Will install these modules."
        echo "Pyton: $(< ${installs} )"
        return
    fi

    sudo pip install --upgrade $(< ${installs} )
    err=$?
    die $err "Failed to install PIP modules!"
}

get_single_lib()
{
    local mod=$1
    local dry=$2

    if [[ $dry ]] ; then
        echo "Will install $1"
        return
    fi

    sudo pip install --upgrade $mod
    err=$?
    die $err "Failed to install $mod pip!"
}

main()
{
    get_libs $INSTALLS $dryrun

    # See https://github.com/sigmavirus24/github3.py
    # See http://github3py.readthedocs.org/en/master/
    get_single_lib "github3.py" $dryrun
    get_single_lib "google-api-python-client" $dryrun
    get_single_lib "gdcmdtools" $dryrun
}
main
