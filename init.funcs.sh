#!/bin/bash - 
#===============================================================================
#         USAGE: source ./int.funcs.sh 
#       CREATED: 01/29/2014 20:22
#===============================================================================
set -o nounset                              # Treat unset variables as an error


## 
# @name InitFuncs.installs
# @description
# Install all the packages
##
installs()
{
    #TODO Use this to run stuff async'ly
    pidList=()

    sudo apt-get -y install \
    bison \
    bison-doc \
    checkinstall \
    cinnamon \
    clang-3.4 \
    cmake \
    debhelper \
    dolphin \
    emacs \
    encfs \
    git \
    git-gui \
    glippy \
    google-chrome-beta \
    hspell \
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
    libedit-dev \
    libedit2 \
    libfreetype6 \
    libgcc1 \
    libgnome2-dev \
    libgnomeui-dev \
    libgtk2.0-dev \
    libluajit-5.1-2 \
    libluajit-5.1-common \
    libluajit-5.1-dev \
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
    openssl \
    pandoc \
    perl-base \
    perl-debug \
    perl-doc \
    perl-modules
    pidgin \
    python-dev \
    python-requests \
    python3 \
    python3-dev \
    python3-requests \
    qct \
    ruby \
    ruby-compass \
    solaar \
    smartmontools \
    traceroute \
    terminator \
    texlive-full \
    tmux \
    tortoisehg \
    touchpad-indicator \
    tree \
    zlib1g \
    #pidList=($!)

    echo -e "\n*** Finished installing everything... now upgrading packages*** \n"
    sudo apt-get dist-upgrade
    sudo apt-get autoremove

    echo -e "\n*** All done getting packages*** \n"
}

## 
# @name InitFuncs.linkifyDots
# @param -r _root_ Root dir to start putting the symlinks
# @param -e _excluded_ Files/dirs to be excluded from linking
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
        ln -s $dotFile ${dotFileStripd}
    done
}

## 
# @name InitFuncs.buildIke
# @description
# Fetch source code and build Shrew Soft VPN (iked)
##
buildIke()
{
    pushd $repos

    # Get the tarball
    wget -O - $url_ike | tar xvf -
    cd ike

    # Make the code
    cmake -DDEBUG=YES -DQTGUI=YES -DNATT=YES -DLDAP=YES
    make
    sudo make install

    popd
}

## 
# @name InitFuncs.buildIke
# @description
# Fetch source code and build VIM. Includes setting up Vundle
##
buildVim()
{
    repos=${repos:-"~/tmp/test"}
    # Remove old version of vim
    sudo apt-get remove vim-tiny vim-common
    sudo dpkg --purge vim vim-tiny vim-common

    # Download the source code
    hg clone https://vim.googlecode.com/hg/ $repos/vim
    hg pull
    hg update

    # Build it
    pushd $repos/vim

./configure --with-features=huge \
    --enable-cscope \
    --enable-luainterp=dynamic \
    --enable-perlinterp=dynamic \
    --enable-pythoninterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-rubyinterp=dynamic \
    --enable-gui=gtk2 \
    --enable-multibyte \
    --enable-largefile \
    --prefix=/usr \
    --with-luajit \
    --with-python-config-dir=/usr/lib/python2.7 \
    --with-x=yes
        
    make VIMRUNTIMEDIR=/usr/share/vim/vim74
    sudo checkinstall -y

    popd

    # Check if vim was properly installed
    which vim 
    if [[ $? == 0 ]] ; then
        echo "Vim installed correctly"
    else
        echo "\n *** Install Failed! *** \n" && return
    fi

    # Get Bundles, install deps, compile YCM (if present)
    vim +BundleInstall +qall

    if [[ -d ~/.vim/bundle/tern_for_vim ]] ; then
        pushd ~/.vim/bundle/tern_for_vim
        npm install
        popd
    fi

    if [[ -d ~/.vim/bundle/YouCompleteMe ]] ; then
        pushd $repos/llvm
        ./configure
        make
        make check-all
        sudo make install

        #cd $repos/clang
        #./configure
        #make
        #sudo make install

        cd ~/.vim/bundle/YouCompleteMe
        echo "*** Compiling YCM ***"
        ./install.sh --clang-completer --omnisharp-completer

        popd
    fi

    # Setup vim as default editor
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
    sudo update-alternatives --set editor /usr/bin/vim
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
    sudo update-alternatives --set vi /usr/bin/vim

}

###
# @name InitFuncs.getSourceCode
# @description
# Fetches source code from varies repos and puts them in
# dir defined by `$repos`
###
getSourceCode(){ 
    repos=${repos:-"~/tmp/test"}
    
    git clone https://github.com/gmarik/vundle.git $vundle
    #pidList=($!)
    git clone http://llvm.org/git/llvm.git $repos/llvm
    #pidList=($!)
    git clone http://llvm.org/git/clang.git $repos/clang
    #pidList=($!)
}

## 
# @name InitFuncs.getTeamViewer
# @description
# Fetch and install Teamviewer
##
getTeamViewer()
{
    pushd $repos
    wget $url_tv  
    sudo dpkg -i $( basename $url_tv )
}

## 
# @name InitFuncs.getStuff
# @description
# Fetch ...
##
getStuff()
{
    echo    
}

## 
# @name InitFuncs.setups
# @description
# Setup dirs, and create generic links
##
setups()
{
    # Set defaults
    repos=${repos:-"~/tmp/test/repos"}
    moveddir=${moveddir:-"~/tmp/test/moved"}
    tmpdir=${tmpdir:-"~/tmp/test"}

    # Create all the dirs
    mkdir -p $vundle $repos $moveddir $tmpdir ~/tmp/{moved,vimbackup,iso}

    # Backup some files
    cp /etc/apt/source.list $moveddir 
    cp /etc/systemd/logind.conf $moveddir

    # Link in bin dir
    ln -s $bin ~/bin
}
