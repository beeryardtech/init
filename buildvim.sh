#!/bin/bash -
##
# @name InitFuncs.buildvim
# @param {string} repos
# @description
# Builds VIM from source code. Includes setting up Vundle
##
cleanup()
{
    echo "#### Trapped in buildvim.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

repos=~/repos/

# Remove old version of vim
sudo apt-get -y remove vim-tiny vim-common
sudo dpkg --purge vim vim-tiny vim-common

pushd "$repos/vim"
# Currently not support using both python and python3... Limit to python2.7 for now
./configure --with-features=huge \
--enable-cscope \
--enable-luainterp \
--enable-perlinterp \
--enable-pythoninterp \
--enable-rubyinterp \
--enable-gui=gtk2 \
--enable-multibyte \
--enable-largefile \
--prefix=/usr \
--with-lua \
--with-luajit \
--with-python-config-dirl=/usr/lib/python2.7 \
--with-x=yes
make clean
make VIMRUNTIMEDIR=/usr/share/vim/vim74

# -D --> Make deb pkg, -y --> accept default values
sudo checkinstall -D -y \
--pkgname vim \
--pkgversion 7.4.192 \
--provides editor \

popd

# Check if vim was properly installed
which vim
if [[ $? == 0 ]] ; then
    echo "Vim installed correctly"
else
    echo "\n *** Install Failed! *** \n" && return
fi

# Setup vim as default editor
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
