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
    echo "#### Trapped in installs.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

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

# Update again after getting keys
sudo apt-get update

# Install Packages
sudo apt-get -y --force-yes install \
adobe-flashplugin \
aircrack-ng \
autossh \
bison \
bison-doc \
checkinstall \
cifs-utils \
cinnamon \
clang-3.4 \
cmake \
dconf-cli \
dconf-editor \
debhelper \
dolphin \
emacs \
encfs \
gedit-developer-plugins \
gedit-latex-plugin \
gedit-plugins \
git \
git-gui \
git-notifier \
git-repair \
gitpkg \
gksu \
google-chrome-beta \
hspell \
jxplorer \
k3b \
kdeconnect \
kdeconnect-kde \
kdiff3 \
keepass2 \
kile \
kile-doc \
finch \
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
sqliteman-doc \
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

echo -e "\n*** Finished installing everything... Now removing Unity stuff...*** \n"

sudo apt-get -y remove unity-webapps-service

echo -e "\n*** Finished removing stuff... Now upgrading packages...*** \n"
sudo apt-get -y --force-yes dist-upgrade
sudo apt-get -y --force-yes autoremove

echo -e "\n*** All done init packages*** \n"
