#!/bin/bash -
cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Fetch source code and build Shrew Soft VPN (iked)

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

$url_ike=https://www.shrew.net/download/ike/ike-2.2.1-release.tgz
repos=$HOME/repos
pushd $repos

# Get the tarball
wget -O - $url_ike | tar xvfz -
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] get code failed! Code: $err"
    exit $err
fi

cd ike

# Make the code
cmake -DDEBUG=YES -DQTGUI=YES -DNATT=YES -DLDAP=YES
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] cmake failed! Code: $err"
    exit $err
fi

make
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] make failed! Code: $err"
    exit $err
fi

sudo make install
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] make install failed! Code: $err"
    exit $err
fi

popd
