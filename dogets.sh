#!/bin/bash -

cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
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
    h) echo $USAGE ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

./gets/getperl.sh $@
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] getperl.sh! Code: $err"
    exit $err
fi

./gets/getpythonlibs.sh $@
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] getpythonlibs.sh failed! Code: $err"
    exit $err
fi

./gets/getsourcecode.sh $@
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] getsourcecode.sh failed! Code: $err"
    exit $err
fi

#./gets/getteamviewer.sh $@
#err=$?
#if [[ $err != 0 ]] ; then
    #echo "[ERROR] getteamviewer.sh failed! Code: $err"
    #exit $err
#fi

## XXX Currently not used
#./gets/getmusictube.sh $@
#err=$?
#if [[ $err != 0 ]] ; then
    #echo "[ERROR] getmusictube.sh failed! Code: $err"
    #exit $err
#fi
