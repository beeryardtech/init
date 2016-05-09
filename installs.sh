#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

## Required for apt-get
check_sudo

read -r -d '' USAGE << "EOF"
Handles the install of all needed packages from apt-get.

- Holds VIM package from dpkg
- Gets and runs "launchpad-getkeys"
- Installs packages, removes unwanted, updates system

optional arguments:
-f    Path to install file
-k    Update keys only
-h    Print this help and exit
-i    Run installs only
-n    Test run, sets apt-get to simulation mode
-r    Path to remove file

EOF

###
# Values
###
INSTALLS="$CURRENT_DIR/files/installs.txt"
REMOVES="$CURRENT_DIR/files/removes.txt"

dryrun=
ASSUME="--assume-yes"
optstring=f:hiknr:
while getopts $optstring opt ; do
    case $opt in
        f) INSTALLS=$OPTARG ; echo "Updating install file to $INSTALLS" ;;
        k) keys_only=true ;;
        h) echo "$USAGE" ; exit 255 ;;
        i) install_only=true ;;
        n) echo "In DryRun Mode" ; dryrun=true ; ASSUME="--dry-run" ;;
        r) REMOVES=$OPTARG ; echo "Updating remove file to $REMOVES" ;;
    esac
done

##
# @name hold
# @param {string} assume Either assume-yes or run simulate mode
# @description
# Put vim on hold, only if it is found
##
hold()
{
    local assume=$1
    local dry=$2

    local find_vim=$( dpkg --list | grep -q "vim" )

    if [[ $dry ]] ; then
        echo "Found vim: $find_vim"
    else
        echo "vim hold" | dpkg --set-selections
    fi

    if [[ $find_vim ]] ; then
        echo "**** VIM package found. Held back"
    else
        echo "**** VIM package not found. Held"
    fi
}

##
# @name update
# @param {string} assume Either assume-yes or run simulate mode
# @description
# Install launchpad getkeys and run that.
##
get_keys()
{
    local assume=$1
    local dry=$2

    apt-get $assume install launchpad-getkeys
    err=$?
    if [[ $err > 0 ]] ; then
        echo "First try to install launchpad-getkeys failed."
        echo "Going to update and try again!"
        apt-get update
        apt-get $assume install launchpad-getkeys
        err=$?

        # Now if that fails, die
        die $err "INSTALL GETKEYS failed!"
    fi

    launchpad-getkeys
    err=$?
    die $err "launchpad-getkeys failed!"

    wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
    err=$?
    die $err "Failed to get the nodesource key!"
}

##
# @name update
# @param {string} assume Either assume-yes or run simulate mode
# @description
# Update all source lists
##
update()
{
    local assume=$1
    local dry=$2

    apt-get update
    err=$?
    die $err "apt-get UPDATE failed!"
}

##
# @name install
# @param {string} assume Either assume-yes or run simulate mode
# @description
# Install all packages
##
install()
{
    local installs=$1
    local assume=$2
    local dry=$3

    if [[ $dry ]] ; then
        echo "Install path: ${installs}"
        return 0
    fi

    if [[ ! -f "${installs}" ]] ; then
        err=1
        die $err "The installs file does not exist!"
    fi

    apt-get $assume install $(< ${installs} )
    err=$?
    die $err "apt-get INSTALL failed!"
}

##
# @name remove
# @param {string} assume Either assume-yes or run simulate mode
# @description
# Remove all packages
##
remove()
{
    local removes=$1
    local assume=$2
    local dry=$3

    if [[ $dry ]] ; then
        echo "Remove path: ${removes}"
        return 0
    fi

    if [[ ! -f "${removes}" ]] ; then
        err=1
        die $err "The removes file does not exist!"
    fi

    apt-get $assume remove $(< ${removes} )
    err=$?
    die $err "apt-get REMOVE failed!"
}

##
# @name remove
# @param {string} assume Either assume-yes or run simulate mode
# @description
# Runs dist-update to update all packages
##
dist()
{
    local assume=$1
    local dry=$2

    apt-get $assume dist-upgrade
    err=$?
    die $err "apt-get DIST-UPGRADE failed!"
}

##
# @name remove
# @param {string} assume Either assume-yes or run simulate mode
# @description
# Runs autoremove of apt-get
##
autoremove()
{
    local assume=$1
    local dry=$2

    apt-get $assume autoremove
    err=$?
    die $err "apt-get AUTOREMOVE failed!"
}

main()
{
    # Should not require any user interactions
    export DEBIAN_FRONTEND=noninteractive


    if [[ $install_only ]] ; then
        install $INSTALLS $ASSUME $dryrun
        exit 0
    fi

    if [[ $keys_only ]] ; then
        get_keys $ASSUME $dryrun
        exit 0
    fi

    # Run everything else
    hold $ASSUME $dryrun
    get_keys $ASSUME $dryrun
    install $INSTALLS $ASSUME $dryrun
    remove $REMOVES $ASSUME $dryrun
    dist $ASSUME $dryrun
    autoremove $ASSUME $dryrun
}
main
