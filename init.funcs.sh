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
# @name InitFuncs.linkifyDots
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

        # Skip dirs.
        if [[ -d $dotFile ]] ; then
            continue
        fi

        # Skip name in exluded list
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
    #git clone http://llvm.org/git/llvm.git $repos/llvm
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
# @name InitFuncs.getteamviewer
# @description
# Fetch and install TeamViewer
##
getteamviewer()
{
    # Needs the 32bit version
    url_tv="http://download.teamviewer.com/download/teamviewer_linux.deb"
    getdeb $url_tv
}

##
# @name InitFuncs.getmusictube
# @description
# Fetch and install music tube
##
getmusictube()
{
    url_mt="http://flavio.tordini.org/files/musictube/musictube64.deb"
    getdeb $url_mt
}

##
# @name InitFuncs.getdeb
# @description
# Fetch and install external deb packages. Tries to handle dependencies with
# `apt-get install -f`
##
getdeb()
{
    url=$1
    name=$( basename $url )
    wget -O /tmp/$name $url
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

    #init=$HOME/Dropbox/repos/beeryardtech/init/
    init=/media/sf_Dropbox/repos/beeryardtech/init

    # What to append to logind.conf
    logind="HandleSuspendKey=suspend\nHandleLidSwitch=ignore\nLidSwitchIgnoreInhibited=no\n"

    # Create all the dirs
    mkdir -p $vundle $repos $moveddir $tmpdir ~/tmp/{moved,iso}

    # Backup some files
    cp /etc/apt/sources.list $moveddir
    cp /etc/systemd/logind.conf $moveddir
    cp /usr/share/X11/xorg.conf.d/20-intel.conf $moveddir

    # Put in place the new files
    sudo cp $init/sources.list.trusty /etc/apt/sources.list
    sudo cp $init/20-intel.conf /usr/share/X11/xorg.conf.d/20-intel.conf
    sudo cp $init/logind.conf /etc/systemd/logind.conf
    #echo -e "\n\n # Added by init.sh\n${logind}" | sudo tee -a $init/logind.conf /etc/systemd/logind.conf

    # Link in bin dir
    echo "Bin dir: $bin"
    ln -s $bin ~/bin
}
