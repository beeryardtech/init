#!/bin/bash -
#===============================================================================
#         USAGE: ./buildike.sh $repos
#       CREATED: 11/16/2014 20:22
#===============================================================================
##
# @name InitFuncs.buildike
# @param {string} repos
# @description
# Fetch source code and build Shrew Soft VPN (iked)
##
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