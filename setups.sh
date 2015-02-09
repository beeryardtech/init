#!/bin/bash -
##
# @name setups.sh
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
cleanup()
{
    echo "#### Trapped in setups.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

# Set defaults
#repos=${repos:-"~/tmp/test/repos"}
#moveddir=${moveddir:-"~/tmp/test/moved"}
#tmpdir=${tmpdir:-"~/tmp/test"}
bin=~/Dropbox/repos/beeryardtech/scripts/bin
dots=~/Dropbox/repos/beeryardtech/scripts/dots
init=~/Dropbox/repos/beeryardtech/init
ip=~/Dropbox/repos/integrityprops/libs
moveddir=~/tmp/moved
repos=~/repos
tmpdir=~/tmp
ui=~/Dropbox/repos/nextgen/ui
vundle=~/.vim/bundle/vundle

# What to append to logind.conf
logind="HandleSuspendKey=suspend\nHandleLidSwitch=ignore\nLidSwitchIgnoreInhibited=no\n"

# Create all the dirs
mkdir -p $vundle $repos $moveddir $tmpdir ~/tmp/{moved,iso}

# Backup some files
echo "START moving files"

cp /etc/apt/sources.list $moveddir
cp /etc/systemd/logind.conf $moveddir
cp /usr/share/X11/xorg.conf.d/20-intel.conf $moveddir


sudo cp $init/sources.list.trusty /etc/apt/sources.list
sudo cp $init/20-intel.conf /usr/share/X11/xorg.conf.d/20-intel.conf
sudo cp $init/logind.conf /etc/systemd/logind.conf

echo "END moving files"

# Put in place the new files
#echo -e "\n\n # Added by init.sh\n${logind}" | sudo tee -a $init/logind.conf /etc/systemd/logind.conf

# Link in bin dir
echo "Bin dir: $bin"
ln -s $bin ~/bin
ln -s $dots ~/dots
ln -s $ip ~/ip
ln -s $ui ~/ui
