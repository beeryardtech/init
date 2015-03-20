#!/bin/bash -
##
# @name setupdropbox.sh
# @description
# Sets up config for dropbox
##
cleanup()
{
    echo "#### Trapped in setups.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM


sysExcludelist=(
    "repos/beeryardtech/scripts/dots/_vim/bundle"
    "repos/nextgen/ui/.sass-cache"
    "repos/nextgen/ui/.tmp"
    "repos/nextgen/ui/build"
    "repos/nextgen/ui/dist"
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


# Install first
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd

if [[ $1 == "-p" ]] ; then
    echo "Using portable exclude list: ${excludelist[@]}"
    dropbox exclude add "${excludelist[@]}"
    exit 0
fi

echo "exclude list: ${excludelist[@]}"
dropbox exclude add "${excludelist[@]}"
