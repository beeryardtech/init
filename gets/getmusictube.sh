#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Gets the newest version of music tube. Uses `wget` to download the deb
package and then uses `dpkg -i` to install it.

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
URL_MT="http://flavio.tordini.org/files/musictube/musictube64.deb"

main()
{
    if [[ $dryrun ]] ; then
        echo "Url: $URL_MT"
        return
    fi

    $CURRENT_DIR/../helpers/getdeb $URL_MT
    $err=$?
    die $err "Failed to get music tube!"
}
main
