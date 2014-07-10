
# We need sudo sometimes and so get user to go ahead and athenticate
sudo echo

# Get this scripts location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup the variables
scripts="$HOME/Dropbox/repos/beeryardtech/scripts"
bin="$scripts/bin"
dots="$scripts/dots"
moveddir="$HOME/tmp/moved"
repos="$HOME/repos"
tmpdir="$HOME/tmp/test"
url_ike="https://www.shrew.net/download/ike/ike-2.2.1-release.tgz"

vundle="$dots/_vim/bundle/vundle"
luajit="$repos/luajit.tar.gz"

# Source in functions
. $DIR/init.funcs.sh

# Setup everything
#setups $bin $repos $moveddir $tmpdir $vundle
#keysetup

# Get all the things (packages)
#installs

#getTeamViewer

# Create links
#linkifyDots -r "$HOME" -e "$dots" $( find $dots -maxdepth 1)

#linkifyDots -r "$HOME/.config" -e "_config" $( find $dots/_config -maxdepth 1)

# Go build some code!
#getsourcecode $repos $vundle
#buildike $repos
#buildvim $repos
#buildvimdeps
#buildycm $repos
#buildluajit $repos $luajit
initsios

#installKDEConnect
