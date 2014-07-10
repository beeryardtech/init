#!/bin/bash -
#===============================================================================
#         USAGE: source ./int.funcs.sh
#       CREATED: 01/29/2014 20:22
#===============================================================================
##
# @name InitFuncs.installKDEConnect
# @description
# Installs and sets up KDE Coonect
##
installKDEConnect()
{
    # Need to make KDE aware of KDE Connect
    kde4d & disown
    qdbus org.kde.kded /kded loadModule kdeconnect
    kbuildsycoca4 -noincremental
}

##
# @name InitFuncs.installs
# @description
# Install all the packages
##
installs()
{
    #sudo apt-get update
    sudo apt-get -y --force-yes install \
    adobe-flashplugin \
    ant \
    bison \
    bison-doc \
    checkinstall \
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
    kdiff3 \
    keepass2 \
    kile \
    kile-doc \
    finch \
    flex \
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
    qt4-qtconfig \
    qt4-doc \
    make \
    maven \
    mercurial \
    mutt \
    nemo-dropbox \
    nodejs \
    nodejs-dbg \
    openjdk-7-jdk \
    openjdk-7-doc \
    openjdk-7-dbg \
    openssh-server \
    openssl \
    pandoc \
    perl-base \
    perl-debug \
    perl-doc \
    perl-modules \
    pidgin \
    pidgin-plugin-pack \
    python-dev \
    python-requests \
    python3 \
    python3-dev \
    python3-requests \
    qct \
    ruby \
    ruby-compass \
    solaar \
    spotify \
    smartmontools \
    traceroute \
    terminator \
    texlive-full \
    tmux \
    tortoisehg \
    touchpad-indicator \
    tree \
    xdotool \
    xubuntu-restricted-extras \
    zlib1g \

    echo -e "\n*** Finished installing everything... now upgrading packages*** \n"
    sudo apt-get -y dist-upgrade
    sudo apt-get autoremove

    echo -e "\n*** All done getting packages*** \n"
}

##
# @name InitFuncs.initsios
# @description
# Inits everything to do with SIOS Tech environment.
##
initsios()
{
    wget -qO - http://repo.sc.steeleye.com/sios_dev_signing_key.asc | sudo apt-key add -
    # Search if source.list has repo already in it

    # If not append to list
    echo -e "\n deb http://repo.sc.steeleye.com/ everest main" | sudo tee -a /etc/apt/sources.list

    # Go get the stuff
    sudo apt-get update && sudo apt-get install cloud-orchestrator cloud-orchestrator--ui
}

##
# @name InitFuncs.linkifyDots
# @param {string} -r _root_ Root dir to start putting the symlinks
# @param {string} -e _excluded_ Files/dirs to be excluded from linking
# @param $@ List of targets to create links to
# @description
# Takes a list of files and creates symlinks to them in user's home dir.
#
# - Example Result:
# Creating link from `/full/path/_foo.txt` to `/home/user/.foo`
#
##
linkifyDots()
{

    if [[ $# == 0 ]] ; then
        touch "~/tmp/test/_bar.txt"
        mkdir -p "~/tmp/test/_foo1"
        excluded="~/tmp/test"
        root="~/tmp/test"
        targetList=$( "~/tmp/test" "~/tmp/test/_bar.txt" "~/tmp/test/_foo1" )
    else
        [[ $1 ==  '-r' ]] && root=$2 && shift 2
        [[ $1 ==  '-e' ]] && excluded=$2 && shift 2
        targetList=$@
    fi

    for dotFile in ${targetList[@]}; do
        base=$( basename $dotFile )

        # Skip dir in exluded
        if [[ $excluded == $base ]] ; then
            continue
        fi

        # The name of the file that will put in home dir
        dotFileStripd=$( echo "$base" | sed 's/.txt$//')

        # Only prefix the dot if led by an underscore
        if [[ ${dotFileStripd:0:1} == '_'  ]] ; then
            dotFileStripd=$(echo $dotFileStripd | sed 's/_/./1' )
        fi

        # Now make it a full path
        dotFileStripd=$root/$dotFileStripd

        # If symlink of the same name already exists then rm it first
        if [ -h ${dotFileStripd} ] ; then
            echo "*** Deleting $dotFileStripd - "
            rm $dotFileStripd
        fi

        # If file or dir exists move
        if [[ -f ${dotFileStripd} || -a ${dotFileStripd} ]] ; then
            echo "*** Moving $dotFileStripd to $tmpdir - "
            mv $dotFileStripd $moveddir
        fi

        echo -e "Creating link from $dotFile to $dotFileStripd \n"
        ln -s "$dotFile" "$dotFileStripd"
    done
}

##
# @name InitFuncs.buildike
# @param {string} repos
# @description
# Fetch source code and build Shrew Soft VPN (iked)
##
buildike()
{
    repos=$1
    pushd $repos

    # Get the tarball
    wget -O - $url_ike | tar xvfz -
    cd ike

    # Make the code
    cmake -DDEBUG=YES -DQTGUI=YES -DNATT=YES -DLDAP=YES
    make
    sudo make install

    popd
}

##
# @name InitFuncs.buildvim
# @param {string} repos
# @description
# Fetch source code and build VIM. Includes setting up Vundle
##
buildvim()
{
    repos=$1

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
    --with-python-config-dir=/usr/lib/python2.7 \
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
}

buildvimdeps()
{
    # Get Bundles, install deps
    vim +BundleInstall +qall

    if [[ -d $HOME/.vim/bundle/tern_for_vim ]] ; then
        pushd $HOME/.vim/bundle/tern_for_vim
        if [[ ! -f $HOME/.vim/bundle/tern_for_vim/package.json ]] ; then
            wget https://raw.githubusercontent.com/marijnh/tern_for_vim/master/package.json
        fi
        npm install
        popd
    fi
}

###
# @name InitFuncs.buildycm
# @param {string} repos
##
buildycm()
{
    repos=$1
    if [[ -d ~/.vim/bundle/YouCompleteMe ]] ; then
        #pushd $repos/llvm
        #./configure
        #make
        #make check-all
        #sudo make install
        #popd

        #cd $repos/clang
        #./configure
        #make
        #sudo make install

        cd $HOME/.vim/bundle/YouCompleteMe
        echo "*** Compiling YCM ***"
        ./install.sh --clang-completer --omnisharp-completer

        popd
    fi
}

###
# @name InitFuncs.getsourcecode
# @param {string} repos
# @description
# Fetches source code from varies repos and puts them in
# dir defined by `$repos`
###
getsourcecode(){
    repos=$1
    vundle=$2

    # Download the source code
    if [[ ! -d "$repos/vim" ]] ; then
        hg clone https://vim.googlecode.com/hg/ "$repos/vim"
    fi

    # Build it
    pushd "$repos/vim"

    hg pull
    hg update

    popd

    git clone https://github.com/gmarik/vundle.git $vundle
    git clone http://llvm.org/git/llvm.git $repos/llvm
    git clone http://llvm.org/git/clang.git $repos/clang
}

##
# @name InitFuncs.buildluajit
# @param {string} repos
# @param {string} luajit
# @description
# Fetch and install lua JIT engine - version 2.0.1
##
buildluajit()
{
    repos=$1
    luajit=$2

    pushd $repos
    wget -O $luajit http://luajit.org/download/LuaJIT-2.0.1.tar.gz
    tar xzvf $luajit -C $repos
    cd $repos/LuaJIT-2.0.1
    make && sudo make install

    popd
}

##
# @name InitFuncs.getTeamViewer
# @param {string} repos
# @description
# Fetch and install Teamviewer
##
getTeamViewer()
{
    # Needs the 32bit version
    url_tv="http://download.teamviewer.com/download/teamviewer_linux.deb"
    name=$( basename $url_tv )
    wget -O /tmp/$name $url_tv
    sudo dpkg -i /tmp/$name

    # Fix missing deps
    sudo apt-get install -f
}

##
# @name InitFuncs.setups
# @param {string} repos
# @param {string} moveddir
# @param {string} tmpdir
# @description
# Setup dirs, and create generic links
##
setups()
{
    # Set defaults
    #repos=${repos:-"~/tmp/test/repos"}
    #moveddir=${moveddir:-"~/tmp/test/moved"}
    #tmpdir=${tmpdir:-"~/tmp/test"}
    bin=$1
    repos=$2
    moveddir=$3
    tmpdir=$4
    vundle=$5

    # Create all the dirs
    mkdir -p $vundle $repos $moveddir $tmpdir ~/tmp/{moved,iso}

    # Backup some files
    cp /etc/apt/sources.list $moveddir
    cp /etc/systemd/logind.conf $moveddir

    # Put in place the new files
    sudo cp $HOME/Dropbox/repos/beeryardtech/init/sources.list.trusty /etc/apt/sources.list

    # Link in bin dir
    echo "Bin dir: $bin"
    ln -s $bin ~/bin
}
