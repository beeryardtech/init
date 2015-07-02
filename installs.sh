#!/bin/bash -
##
# @name installs.sh
# @description
# Install all the packages. Does the following setup:
#
# - Put the VIM package on hold
# - Run apt-get update
# - Install the packages
# - Remove unity-webapps-service
# - Autoremove all unneeded packages
# - Run dist-update
##

# Only should be ran as root
#if [[ $EUID != 0 ]] ; then
    #echo "Run this script as root" 1>&2
    #exit 1
#fi

cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Handles the install of all needed packages from apt-get.

- Holds VIM package from dpkg
- Gets and runs "launchpad-getkeys"
- Runs apt-get install
- Removes unwanted packages
- Does system update

EOF

if [[ "$1" == "-h" ]] ; then
    echo $USAGE
    exit 1;
fi

# Grab sudo creds
sudo echo

# Put vim on hold, only if it is found
echo vim hold | sudo dpkg --set-selections
if [[ $( dpkg --list | grep -q "vim" ) ]] ; then
    echo "**** VIM package found. Held back"
else
    echo "**** VIM package not found. Held"
fi

# Auto get missing keys
sudo apt-get -y --force-yes install launchpad-getkeys
sudo launchpad-getkeys

err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] launchpad-getkeys failed! Code: $err"
    exit $err
fi

# Update again after getting keys
sudo apt-get update

err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] apt-get update failed! Code: $err"
    exit $err
fi

# Install Packages
sudo apt-get -y --force-yes install \
adobe-flashplugin \
aircrack-ng \
apt-files \
autossh \
baloo \
banshee \
bison \
bison-doc \
checkinstall \
cifs-utils \
cinnamon \
clang-3.4 \
cmake \
davfs2 \
dconf-cli \
dconf-editor \
debhelper \
dolphin \
dosbox \
emacs \
encfs \
finch \
gedit-developer-plugins \
gedit-latex-plugin \
gedit-plugins \
gimp \
git \
git-gui \
git-notifier \
git-repair \
gitpkg \
gksu \
google-chrome-beta \
gufw \
htop \
hspell \
indicator-kdeconnect \
jxplorer \
k3b \
kdeconnect \
kdiff3 \
keepass2 \
kile \
kile-doc \
launchpad-getkeys \
libasound2 \
libatk1.0-dev \
libbonoboui2-dev \
libc6 \
libcairo2-dev \
libcroco-tools \
libedit-dev \
libedit2 \
libfreetype6 \
libgcc1 \
libgnome2-dev \
libgnomeui-dev \
libgtk2.0-dev \
libk3b6-extracodecs \
libperl-critic-perl \
libperl-dev \
libncurses5 \
libncurses5-dev \
libqt4-dev \
libsm6 \
libssl-dev \
libx11-dev \
libxdamage1 \
libxext6 \
libxfixes3 \
libxpm-dev \
libxrandr2 \
libxrender1 \
libxt-dev \
libxtst6 \
qdbus-qt5 \
qt5-default \
qt5-doc \
make \
maven \
mercurial \
mplayer \
mutt \
pinta \
nemo-dropbox \
nfs-common \
nfs-kernel-server \
nodejs \
nodejs-dbg \
node-sqlite3 \
openjdk-7-jdk \
openjdk-7-doc \
openjdk-7-dbg \
openssh-server \
openssl \
okular \
pandoc \
perl-base \
perl-debug \
perl-doc \
perl-modules \
pidgin \
pidgin-indicator \
pidgin-plugin-pack \
playonlinux \
python-dev \
python-pip \
python-requests \
python3 \
python3-dev \
python3-requests \
qct \
rdesktop \
ruby \
ruby-compass \
ruby-sqlite3 \
sqliteman \
sqliteman-doc \get
solaar \
spotify-client \
smartmontools \
terminator \
texlive-full \
tmux \
traceroute \
tortoisehg \
tree \
wine \
xclip \
xdotool \
xubuntu-restricted-extras \
youtube-dl \
virtualbox \
vlc \
zlib1g \

err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] apt-get INSTALL failed! Code: $err"
    exit $err
fi

echo -e "\n*** Finished installing everything... Now removing Unity stuff...*** \n"

sudo apt-get -y remove unity-webapps-service

echo -e "\n*** Finished removing stuff... Now upgrading packages...*** \n"
sudo apt-get -y --force-yes dist-upgrade
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] dist-update failed! Code: $err"
    exit $err
fi

sudo apt-get -y --force-yes autoremove
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] autoremove failed! Code: $err"
    exit $err
fi

echo -e "\n*** All done init packages*** \n"
