#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Builds VIM from source code.

optional arguments:
-h    Print this help and exit
-n    Test run

EOF

##
# Values
##
REPO=~/repos/vim
CHECK_ARGS="${CURRENT_DIR}/../files/vim_check_args.txt"
CONFIG_ARGS="${CURRENT_DIR}/../files/vim_config_args.txt"

remove_vim()
{
    local dry=$1
    local vim_pkg="vim vim-tiny vim-common"

    if [[ $dry ]] ; then
        echo "Packages to remove: $vim_pkg"
        sudo apt-get --assume-no remove "$vim_pkg"
        return
    fi

    sudo apt-get --assume-yes remove "$vim_pkg"
    sudo dpkg --purge "$vim_pkg"
}

config_build()
{
    local arg_file=$1
    local dry=$2
    local script="./configure"

    if [[ $dry ]] ; then
        [[ -d "$arg_file" ]] && exists=true || exists=false
        echo "Arg file exists: $exists"
        echo "Args: $(< ${arg_file} )"
        return
    fi

    if [[ ! -f "$arg_file" ]] ; then
        die 1 "Args file does not exist! arg_file: $arg_file"
    elif [[ ! -f "$script" ]] ; then
        die 1 "Config script does not exist! script: $script"
    elif [[ ! -x "$script" ]] ; then
        die 1 "Config script is not executable! script: $script"
    fi

    ${script} $(< ${arg_file} )
    err=$?
    die $err "Failed to config vim! Arg file: $arg_file Args: $(< ${arg_file} )"
}

do_make()
{
    local dry=$1
    local args="VIMRUNTIMEDIR=/usr/share/vim/vim74"

    if [[ $dry ]] ; then
        echo "Args: $args"
        return
    fi

    make clean
    err=$?
    die $err "Make clean failed!"

    make "$args"
    err=$?
    die $err "Make failed! Args: $args"
}

check_install()
{
    local arg_file=$1
    local dry=$2

    if [[ $dry ]] ; then
        [[ -d "$arg_file" ]] && exists=true || exists=false
        echo "Arg file exists: $exists"
        echo "Args: $(< ${arg_file} )"
        return
    fi

    sudo checkinstall $(< ${arg_file} )
    err=$?
    die $err "Check install failed! Arg file: $arg_file Args: $(< ${arg_file} )"
}

update_alts()
{
    local dry=$1

    if [[ $dry ]] ; then
        echo "Update alts"
        return
    fi

    # Setup vim as default editor
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
    sudo update-alternatives --set editor /usr/bin/vim
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
    sudo update-alternatives --set vi /usr/bin/vim
}

vim_check()
{
    which vim
    err=$?
    die $err "Install failed! Vim is not available"
}

main()
{
    sudo echo

    pushd "$REPO"

    # Run install processes
    remove_vim $dryrun
    config_build $CONFIG_ARGS $dryrun
    do_make $dryrun
    check_install $CHECK_ARGS $dryrun
    update_alts $dryrun
    vim_check

    popd
}
main
