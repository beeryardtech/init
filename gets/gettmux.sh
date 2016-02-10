#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Get the newest deb package for tmux. Also, installs TPM.

When done open tmux and press PREFIX I to get all the
other plugins

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

##
# Values
##
GET_DEB=$CURRENT_DIR/../helpers/getdeb.sh
TPM_DIR=~/.tmux/plugins/tpm
URL_TMUX="http://ftp.us.debian.org/debian/pool/main/t/tmux/tmux_2.0-3~bpo8+1_amd64.deb"
URL_TPM="https://github.com/tmux-plugins/tpm"

get_tmux()
{
    local dry=$1

    if [[ $dryrun ]] ; then
        echo "Url: $URL_TMUX"
        return
    fi
    $GET_DEB $URL_TMUX
}

get_tpm()
{
    local repo=$1
    local dry=$2

    if [[ $dry ]] ; then
        [[ -d "$repo" ]] && exists=true || exists=false
        echo "Clone from url: $URL_TPM"
        echo "Clone to dir: $repo"
        echo "Dir exists: $exist"
        return
    fi

    # Now get the tmux plugin manager
    if [[ ! -d "$repo" ]] ; then
        mkdir -p "$repo"
        git clone $url "$repo"
    else
        echo "Directory exists. Not cloning."
    fi

    if [[ -d "$repo/.git" ]] ; then
        echo "TPM dir is a GIT repo, trying to update"
        pushd "$repo"

        git pull
        err=$?
        die $err "TPM update failed!"

        popd
    fi
}

get_tpm_plugins()
{
    local dir="$1"
    local dry=$2
    local script="${dir}/scripts/install_plugins.sh"

    if [[ $dry ]] ; then
        echo "Script to install TPM Modules: $scipt"
        return
    fi

    if [[ -f "${script}" && -x "${script}" ]] ; then
        echo "Installing TPM Plugins..."

        ${script}
        err=$?
        die $err "Failed to install TPM Modules!"

    elif [[ ! -x "${script}" ]] ; then
        err=1
        die $err "Install script exists but not executable! Path: $script"

    else
        err=1
        die $err "Install script not there! Path: $script"

    fi
}

main()
{
    get_tmux $dryrun
    get_tpm "$TPM_DIR" $dryrun
    get_tpm_plugins "$TPM_DIR" $dryrun
}
main
