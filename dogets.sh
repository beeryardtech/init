#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Runs the "get" init scripts and checks results.
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
    h) echo "$USAGE" ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

#./gets/getperl.sh $@
#err=$?
#die $err "getperl.sh failed!"

#./gets/getpythonlibs.sh $@
#err=$?
#die $err "getpythonlibs.sh failed!"

./gets/getsourcecode.sh $@
err=$?
die $err "getsourcecode.sh failed!"

./gets/getteamviewer.sh $@
err=$?
die $err "getteamviewer.sh failed!"
