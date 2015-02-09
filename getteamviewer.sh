#!/bin/bash -
###
# @name Init.getteamviewer
# @description
# Gets the newest version of TeamViewer. Uses `wget` to download the deb
# package and then uses `dpkg -i` to install it.
##
cleanup()
{
    echo "#### Trapped in buildycm.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

. ./init.funcs.sh

# Needs the 32bit version
url_tv="http://download.teamviewer.com/download/teamviewer_linux.deb"
getdeb $url_tv
