#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Gets the newest version of TeamViewer. Uses `wget` to download the deb
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

URL_TV="http://download.teamviewer.com/download/teamviewer_linux.deb"

main()
{
    # Needs the 32bit version
    if [[ $dryrun ]] ; then
        echo "Url: $URL_TV"
        return
    fi

    $CURRENT_DIR/../helpers/getdeb.sh $URL_TV
    err=$?
    die $err "Failed to get TeamViewer!"
}
main
