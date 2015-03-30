#!/bin/bash -
##
# @name setupwine.sh
# @param {string} -e _excluded_ Files/dirs to be excluded from linking
# @description
# Creates the symlinks for backups for the WINE home directory. Requires that the
# Destination dirs are available and writable.
##
cleanup()
{
    echo "#### Trapped in $( basename $0 ) Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

$moveddir=~/tmp/moved
$srcDir=~/.wine/
$destDir=~/Dropbox/shared/backup/wine/

targetList=(
    "system.reg"
    "user.reg"
    "userdef.reg"
    "drive_c/GOG Games/"
    "drive_c/Program Files/"
    "drive_c/tgoldie/Application Data/"
)

for trgt in ${targetList[@]} ; do
    target=$srcDir/$trgt
    finalDest=$destDir/$trgt

    if [[ -f ${target} || -a ${target} ]] ; then
        echo "Moving $target to $movedir"
        mv $target $movedir
    fi

    # If symlink of the same name already exists then rm it first
    if [[ -h ${finalDest} ]] ; then
        echo "*** Deleting $finalDest - "
        rm $finalDest
    fi

    echo -e "Creating link from $trgt to $finalDest \n"
    ln -s "$target" "$finalDest"
done


