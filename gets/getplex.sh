#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Gets the newest version of Plex Server. Uses `wget` to download the deb
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

URL_PLEX="https://downloads.plex.tv/plex-media-server/0.9.12.19.1537-f38ac80/plexmediaserver_0.9.12.19.1537-f38ac80_amd64.deb"

main()
{
    if [[ $dryrun ]] ; then
        echo "Url: $URL_PLEX"
        return
    fi

    $CURRENT_DIR/../helpers/getdeb.sh $URL_PLEX
    err=$?
    die $err "Failed to get Plex!"
}
main
