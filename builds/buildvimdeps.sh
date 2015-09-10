#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/../helpers/helpers.sh"
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
    h) echo "$USAGE" ; exit 255 ;;
    n) dryrun=true ;;
    esac
done

##
# Values
##
BUNDLE="~/.vim/bundle"

# Tern
REPO_TERN="${BUNDLE}/tern_for_vim"
TERN_PACKAGE_FILE="${REPO_TERN}/package.json"
TERN_PACKAGE_URL="https://raw.githubusercontent.com/marijnh/tern_for_vim/master/package.json"
NPM_REGISTRY="http://registry.npmjs.org/"

# Vundle
REPO_VUNDLE="${BUNDLE}/vundle.git"
URL_VUNDLE="https://github.com/gmarik/vundle.git"

get_vundle()
{
    local url="$1"
    local repo="$2"

    if [[ $dry ]] ; then
        [[ -d "$repo" ]] && exists=true || exists=false
        echo "Clone url: $url"
        echo "Clone repo: $repo"
        echo "Repo exists: $exists"
        return
    fi

    # Delete the existing directory first
    if [[ -d "$repo" ]] ; then
        rm -rf "$repo"
    fi

    git clone "$url" "$repo"
    err=$?
    die $err "Failed to clone Vundle!"
}

get_plugins()
{
    local dry=$1
    local args="+PluginInstall +qall"

    if [[ $dry ]] ; then
        echo "Args: $args"
        return
    fi

    vim "$args"
    err=$?
    die $err "Failed to install plugins!"
}

get_tern_package_json()
{
    local path=$1
    local url=$2
    local dry=$3

    if [[ $dry ]] ; then
        [[ -f "$path" ]] && exists=true || exists=false
        echo "Tern package.json path: $path"
        echo "Tern package.json url: $url"
        echo "Tern package.json exists: $exists"
        return
    fi

    if [[ ! -f "$path" ]] ; then
        wget -O "$path" "$url"
        err=$?
        die $err "Failed to fetch tern package.json! Path: $path Url: $url"
    fi
}

install_tern()
{
    local dir=$1
    local reg=$2
    local dry=$3

    if [[ $dry ]] ; then
        echo "Directory: $dir"
        echo "Registry: $reg"
        return
    fi

    pushd $dir
    npm --registry "$reg" install
    popd
}

main()
{

    get_vundle "$URL_VUNDLE" "$REPO_TERN" $dryrun
    get_plugins $dryrun
    get_tern_package_json "$TERN_PACKAGE_FILE" "$TERN_PACKAGE_URL" $dryrun
    install_tern "$REPO_TERN" "$NPM_REGISTRY" $dryrun
}
main
