#!/bin/bash -
##
# @name setupwine.sh
# @param {string} -e _excluded_ Files/dirs to be excluded from linking
# @description
##
cleanup()
{
    echo "#### Trapped in $( basename $0 ) Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Creates the symlinks for backups for the WINE home directory. Requires that the
Destination dirs are available and writable.

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

moveddir=~/tmp/moved
srcDir=~/.wine/
destDir=~/Dropbox/shared/backup/wine/

targetList=(
    "system.reg"
    "user.reg"
    "userdef.reg"
    "drive_c/GOG Games/"
    "drive_c/Program Files/"
    "drive_c/users/tgoldie/Application Data/"
)

# XXX Must use indices instead of for-in when elems have spaces
for (( i=0; i < ${#targetList[@]}; i++ )) ; do
    target="$srcDir/${targetList[$i]}"
    finalDest="$destDir/${targetList[$i]}"

    if [[ -f "${target}" || -a "${target}" ]] ; then
        echo "Moving $target to $moveddir"
        mv "$target" "$moveddir"
    fi

    # If symlink of the same name already exists then rm it first
    if [[ -h "${finalDest}" ]] ; then
        echo "*** Deleting link $finalDest - "
        rm "$finalDest"
    fi

    echo -e "Creating link from $target to $finalDest \n"
    ln -s "$target" "$finalDest"
done


