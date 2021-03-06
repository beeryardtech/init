#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Runs the "BUILD" init scripts and checks results.
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

main()
{
    ./builds/buildvim.sh $@
    err=$?
    die $err "buildvim.sh failed!"

    ./builds/buildvimdeps.sh $@
    err=$?
    die $err "builddeps.sh failed!"

    ./builds/buildycm.sh $@
    err=$?
    die $err "buildycm.sh failed!"

    ./builds/buildike.sh $@
    err=$?
    die $err "buildike.sh failed!"

    echo "*** Builds have finished! *** "
}
main $@

