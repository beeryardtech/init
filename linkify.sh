#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Takes a list of files and creates symlinks to them in user's home dir.
By default skips directories and only does folders

- Example Result:
Creating link from `/full/path/_foo.txt` to `/home/user/.foo`

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dest="$HOME"
movedir="$HOME/tmp/moved"
root="$HOME/Dropbox/repos/beeryardtech/dots"
LINK_LIST="$CURRENT_DIR/files/link_list.txt"

dryrun=
optstring=f:hnr:
while getopts $optstring opt ; do
    case $opt in
    	f) LINK_LIST=$OPTARG ; echo "Updated link list file $LINK_LIST" ;;
        h) echo "$USAGE" ; exit 255 ;;
    	n) dryrun=true ;;
        r) root=$OPTARG ; echo "Updated root directory to $root" ;;
    esac
done

do_linkify()
{
    local dotsList=$@

    ###
    # Excludes
    # '_kde/share/config/kdeconnectrc.txt' # Do not link - causes sigfault
    ###
    for dotFile in ${dotsList[@]}; do
        base=$( basename $dotFile )

        # Skip name in exluded list
        if [[ $excluded == $base ]] ; then
            continue
        fi

        # The name of the file that will put in home dir
        # Strip the ".txt" from the end of the file name
        dotFileStripd=$( echo "$dotFile" | sed 's/.txt$//')

        # Only prefix the dot if led by an underscore
        if [[ ${dotFileStripd:0:1} == '_'  ]] ; then
            dotFileStripd=$(echo $dotFileStripd | sed 's/_/./1' )
        fi

        # Now make it a full path to file. This is the destination path
        finalDest="${dest}/$dotFileStripd"

        # Test if containing directory exists. If not make it
        finalDestDir="$(dirname $finalDest)"

        if [[ ! -d $finalDestDir ]] ; then
            echo "Final Dest Dir did not exist: $finalDestDir"

            [[ $dryrun ]] || mkdir -p $finalDestDir

            echo "Final Dest Dir created!"
        fi

        # If symlink of the same name already exists then rm it first
        if [[ -h ${finalDest} ]] ; then
            echo "*** Deleting $finalDest - "
            [[ $dryrun ]] || rm $finalDest
        fi

        # If file or dir exists move
        if [[ -f ${finalDest} || -a ${dotFileStripd} ]] ; then
            echo "*** Moving $finalDest to $movedir - "
            [[ $dryrun ]] || mv $finalDest $movedir
        fi

        echo "Root: $root dest: $dest"
        echo
        echo "Creating link from $root/$dotFile to $finalDest"
        [[ $dryrun ]] || ln -s "$root/$dotFile" "${finalDest}"
    done
}

main()
{
    do_linkify $(< ${LINK_LIST})
}
main
