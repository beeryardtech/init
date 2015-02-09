#!/bin/bash -
##
# @name linkifydots
# @param {string} -r _root_ Root dir to start putting the symlinks
# @param {string} -e _excluded_ Files/dirs to be excluded from linking
# @param $@ List of targets to create links to
# @description
# Takes a list of files and creates symlinks to them in user's home dir.
#
# By default skips directories and only does folders
#
# - Example Result:
# Creating link from `/full/path/_foo.txt` to `/home/user/.foo`
#
##
# Only should be ran as root
# if [[ $EUID -ne 0 ]]; then
    # echo "Run this script as root" 1>&2
    # exit 1
# fi
cleanup()
{
    echo "#### Trapped in linkify.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM


# Setup arguments
optstring=:d:De:m:r:
while getopts $optstring opt ; do
    case $opt in
        d) # Set destination dir
            dest=$OPTARG ;;
        D) # Use default values
            dest=/home/tgoldie/
            movedir=/home/tgoldie/tmp/moved
            root=/home/tgoldie/Dropbox/repos/beeryardtech/scripts/dots ;;
        e) # Set files and dirs to exclude
            excluded=$OPTARG ;;
        m) # The direcotry to move stuff to
            movedir=$OPTARG ;;
        r) # Root directory
            root=$OPTARG ;;
    esac
done
targetList=$@

targetList=(
    '_bash_aliases.txt'
    '_bash_funcs.txt'
    '_bash_logout.txt'
    '_bash_ps1.txt'
    '_bashrc.txt'
    '_gitconfig.txt'
    '_gntrc.txt'
    '_gvimrc.txt'
    '_inputrc.txt'
    '_muttrc.steeleye.txt'
    '_muttrc.tgoldie.txt'
    '_muttrc.txt'
    '_NERDTreeBookmarks.txt'
    '_npmrc.txt'
    '_profile.txt'
    '_tmux.conf.txt'
    '_vimperatorrc.txt'
    '_vimrc.txt'
    '_vimrc.config.txt'
    '_vimrc.funcs.txt'
    '_vimrc.js.txt'
    '_vimrc.plugins.txt'
    '_vrapperrc.txt'
    '_ssh'
    '_config/KeePass'
    '_config/gedit'
    '_config/terminator'
    '_purple'
    '_vim'
    '_vimperator'
)

for dotFile in ${targetList[@]}; do
    base=$( basename $dotFile )

    # Skip name in exluded list
    if [[ $excluded == $base ]] ; then
        continue
    fi

    # The name of the file that will put in home dir
    dotFileStripd=$( echo "$dotFile" | sed 's/.txt$//')

    # Only prefix the dot if led by an underscore
    if [[ ${dotFileStripd:0:1} == '_'  ]] ; then
        dotFileStripd=$(echo $dotFileStripd | sed 's/_/./1' )
    fi

    # Now make it a full path. This is the destination path
    finalDest="${dest}/$dotFileStripd"

    # If symlink of the same name already exists then rm it first
    if [ -h ${finalDest} ] ; then
        echo "*** Deleting $finalDest - "
        rm $finalDest
    fi

    # If file or dir exists move
    if [[ -f ${finalDest} || -a ${dotFileStripd} ]] ; then
        echo "*** Moving $finalDest to $movedir - "
        mv $finalDest $moveddir
    fi

    echo -e "Creating link from $dotFile to $finalDest \n"
    echo "Root: $root dest: $dest"
    ln -s "$root/$dotFile" "${finalDest}"
done
