#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Creates the symlinks for backups for the WINE home directory. Requires that the
Destination dirs are available and writable.

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dryrun=false
optstring=hn
while getopts $optstring opt ; do
    case $opt in
    h) echo "$USAGE" ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

##
# Values
##
TARGET_LIST="${CURRENT_DIR}/../files/wine_target_list.txt"

moveddir=~/tmp/moved
destDir=~/.wine/
srcDir=~/Dropbox/shared/backup/wine/

targetList=$(< $TARGET_LIST)

do_linkify()
{
    # TODO
    #local dry=$1

    # XXX Must use indices instead of for-in when elems have spaces
    for (( i=0; i < ${#targetList[@]}; i++ )) ; do
        target="$srcDir/${targetList[$i]}"
        finalDest="$destDir/${targetList[$i]}"

        if [[ -f "${target}" || -a "${target}" ]] ; then
            echo "Moving $target to $moveddir"
            [[ $dryrun == false ]] && mv "$target" "$moveddir"
        fi

        # Test if containing directory exists. If not make it
        finalDestDir="$(dirname "$finalDest")"

        if [[ ! -d "$finalDestDir" ]] ; then
            echo "Final Dest Dir did not exist: $finalDestDir"
            [[ $dryrun -eq false ]] && mkdir -p "$finalDestDir"
            echo "Final Dest Dir created!"
        fi

        # If symlink of the same name already exists then rm it first
        if [[ -h "${finalDest}" ]] ; then
            echo "*** Deleting link $finalDest - "
            [[ $dryrun == false ]] && rm "$finalDest"
        fi

        echo -e "Creating link from $target to $finalDest \n"
        [[ $dryrun == false ]] && ln -s "$target" "$finalDest"
    done

}

main()
{
    do_linkify $dryrun
}
main
