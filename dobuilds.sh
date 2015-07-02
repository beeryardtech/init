#!/bin/bash -
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

./builds/buildvim.sh $@
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] buildvim.sh failed! Code: $err"
    exit $err
fi

./builds/buildvimdeps.sh $@
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] buildvimdeps.sh failed! Code: $err"
    exit $err
fi

./builds/buildycm.sh $@
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] buildycm.sh failed! Code: $err"
    exit $err
fi

./builds/buildike.sh $@
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] buildike.sh failed! Code: $err"
    exit $err
fi
