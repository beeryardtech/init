###
# @name InitFuncs.getsourcecode
# @param {string} repos
# @description
# Fetches source code from varies repos and puts them in
# dir defined by `$repos`
###
cleanup()
{
    echo "#### Trapped in buildycm.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

repos=~/repos
vundle=~/.vim/bundle/vundle

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
