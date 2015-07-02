#!/bin/bash -
##
# @name setupdropbox.sh
# @description
# Sets up config for dropbox
##
cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Installs Dropbox and setups up exlude list

optional arguments:
-e    Apply the normal exclude list
-i    Get and run the dropbox installer
-p    Apply the portable exclude list

EOF



normExcludeList=(
    "repos/beeryardtech/scripts/dots/_vim/bundle"
    "repos/nextgen/ui/.sass-cache"
    "repos/nextgen/ui/.tmp"
    "repos/nextgen/ui/build"
    "repos/nextgen/ui/dist"
    "repos/nextgen/ui/node_modules"
    "repos/nextgen/ui/target"
)

# Includes
# APG
# repos/beeryardtech
# repos/integrityprops

portableExcludeList=(
    "Accounting"
    "Apps"
    "Camera Uploads"
    "ebooks"
    "importanttechdoc/"
    "janie/"
    "Music/"
    "Photos/"
    "Programs/"
    "Public/"
    "repos/beeryardtech/scripts/dots/_vim/bundle"
    "repos/integrityprops/"
    "repos/keepass-node/"
    "repos/nextgen/"
    "repos/python/"
    "Screenshots/"
    "SIOS/"
    "Videos/"
)

if [[ $# == 0 || $1 == "-h" ]] ; then
    echo "USAGE: $USAGE"
fi

# Install first
if [[ $1 == "-i" ]] ; then
    shift

    cd ~
    wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    err=$?
    if [[ $err != 0 ]] ; then
        echo "[ERROR] Failed to download dropbox! Code: $err"
        exit $err
    fi

    ~/.dropbox-dist/dropboxd
    err=$?
    if [[ $err != 0 ]] ; then
        echo "[ERROR] Failed to start dropboxd! Code: $err"
        exit $err
    fi
fi

if [[ $1 == "-p" ]] ; then
    shift

    echo "[INFO] (PORTABLE) Exclude list: ${portableExcludeList[@]}"
    dropbox exclude add "${portableExcludeList[@]}"
    err=$?
    if [[ $err != 0 ]] ; then
        echo "[ERROR] Failed to set PORTABLE exclude list! Code: $err"
        exit $err
    fi
fi

if [[ $1 == "-e" ]] ; then
    shift

    echo "[INFO] (NORMAL) Exclude list: ${normExcludeList[@]}"
    dropbox exclude add "${normExcludeList[@]}"
    err=$?
    if [[ $err != 0 ]] ; then
        echo "[ERROR] Failed to set NORMAL exclude list! Code: $err"
        exit $err
    fi
fi
