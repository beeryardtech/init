#!/bin/bash -
cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Gets and installs all the plugins (using vundle) and
runs any additional build steps (for example, npm install)

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

dryrun=
optstring=hn
while getopts $optstring opt ; do
    case $opt in
    h) echo $USAGE ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Get Bundles, install deps
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/Vundle.vim
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] Failed to clone vundle! Code: $err"
    exit $err
fi

vim +PluginInstall +qall
err=$?
if [[ $err != 0 ]] ; then
    echo "[ERROR] Failed to install plugins! Code: $err"
    exit $err
fi

if [[ -d $HOME/.vim/bundle/tern_for_vim ]] ; then
    pushd $HOME/.vim/bundle/tern_for_vim
    echo "*** Compiling TERN ***"
    if [[ ! -f $HOME/.vim/bundle/tern_for_vim/package.json ]] ; then
        wget https://raw.githubusercontent.com/marijnh/tern_for_vim/master/package.json
        err=$?
        if [[ $err != 0 ]] ; then
            echo "[ERROR] Failed to get tern package.json! Code: $err"
            exit $err
        fi
    fi

    npm install
    err=$?
    if [[ $err != 0 ]] ; then
        echo "[ERROR] npm install failed! Code: $err"
        exit $err
    fi

    popd

else
    # Else, through error!
    echo "[ERROR] Tern_For_Vim Directory does not exist!"
    exit 1
fi

