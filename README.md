init
=====
Scripts and packages to help get my systems going.

### Setup Home directory
- Create dirs: tmp, .sshkeys, Private, SharedPrivate
- make symlinks


### Disable IPv6!

- Add The following to `/etc/sysctrl.conf`

``` bash
###
# Disable IPv6
###
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```
### Wget apps

``` bash
wget -O https://www.shrew.net/download/ike/ike-2.2.1-release.tgz ~/tmp | tar xvf -
```

### Update and Prepare Apt-Get
- Copy `/etc/apt/source.list` to `/etc/apt/source.list.install`
- Replace with init version
- Run `aptget.init.sh`
- Then it will try to fetch all the gpg keys.
- *TODO* Cleanup source.list.d after run.
- *TODO* List of keys that fail during a run

### Package list
- TODO Move this list to to deb metapackage when that is done...
- See ./installs.sh for list of packages


### Perl Modules

``` bash
cpan -i Sort/Natuarlly.pm \
Term/ReadKey.pm \
Term/ShellUI.pm \
File/KeePass.pm
```
### To change Screensaver lock for cinnamon
- Open dconf editor
- org -> cinnamon -> desktop -> settings-daemon -> media-keys -> "screensaver"
- Apply settings

### To prevent suspend when lid closed
- Edit /etc/logind.conf
- Change the following values:
    - HandleLidSwitch=ignore
    - LidSwitchIgnoreInhibited=no

### link stuff
- Link all files in ~/Dropbox/shared/all/ to their corresponding locations
- Ask user if to overwrite existing files, or backup them up
    - Move file x to x.orig, then create symlink
- Will need to be done after dropbox is done.
- Maybe fetch only shared dir and place in dropbox before drobpox finishes??

### vim - Tern for Vim

### vim
#### Source Code
``` bash
sudo apt-get remove vim vim-tiny vim-common
mkdir -p ~/repos
hg clone https://vim.googlecode.com/hg/ ~/repos/vim
hg pull
hg update
```

#### Tern For VIM
- `cd ~/.vim/bundle/tern_for_vim`
- Run `npm install` in bundle directory

#### YouCompleteMe
- From source code dir, run
- Must first have ~/.vimrc in place to get bundles

```bash
./configure --with-features=huge \
--enable-rubyinterp \
--enable-luainterp \
--enable-pythoninterp \
--with-python-config-dir=/usr/lib/python2.7-config \
--enable-perlinterp \
--enable-gui=gtk2 \
--enable-cscope \
--prefix=/usr \
--enable-multibyte \
--with-x=yes \

make VIMRUNTIMEDIR=/usr/share/vim/vim74
sudo checkinstall -y
./install.sh --clang-completer
vim +BundleInstall
```

#### Set VIM as default editor
``` bash
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
```
