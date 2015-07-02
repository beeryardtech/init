#!/bin/bash -

cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Gets any external python libraries.

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

# Needed by gdcmdtools
sudo pip install --upgrade \
oauth2client \
apiclient \
discovery \

err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] Failed to install FIRST pip! Code: $err"
    exit $err
fi

echo

sudo pip install --upgrade google-api-python-client
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] Failed to install google-api-python-client pip! Code: $err"
    exit $err
fi

sudo pip install --upgrade gdcmdtools
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] Failed to install gdcmdtools pip! Code: $err"
    exit $err
fi

echo -e "\n *** Finished installing all Python Libs... ***"
