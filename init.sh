
# We need sudo sometimes and so get user to go ahead and athenticate
sudo echo

# Setup the variables
bin="$scripts/bin"
dots="$scripts/dots"
moveddir="~/tmp/moved"
repos="~/repos"
scripts="~/Dropbox/repos/beeryardtech/scripts"
tmpdir="~/tmp/test"
url_ike="https://www.shrew.net/download/ike/ike-2.2.1-release.tgz"
url_tv="http://download.teamviewer.com/download/teamviewer_linux.deb" # need the 32bit version
#vundle="~/.vim/bundle/vundle"
vundle="$dots/_vim/bundle/vundle"

. init.funcs.sh

# Setup everything
setups
keysetup

# Get all the things (packages)
installs

# Create links
linkifyDots -r "~" -e "$dots" $( find $dots -maxdepth 1)

linkifyDots -r "~/.config" -e "_config" $( find $dots/_config -maxdepth 1)

# Go build some code!
buildIke

buildVim
