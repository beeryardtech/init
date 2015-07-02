#!/bin/bash -
###
# @name InitFuncs.getmusictube
# @description
# Gets the newest version of music tube. Uses `wget` to download the deb
# package and then uses `dpkg -i` to install it.
##
cleanup()
{
    echo "#### Trapped in buildycm.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

. ./init.funcs.sh

url_mt="http://flavio.tordini.org/files/musictube/musictube64.deb"
getdeb $url_mt
