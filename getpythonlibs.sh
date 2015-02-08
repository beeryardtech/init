#!/bin/bash -
#===============================================================================
#         USAGE: ./getpylibs.sh
#       CREATED: 11/14/2014 20:22
#===============================================================================
###
# @name Init.getpylibs
# @description
# Get additional python libs (using PIP)
##
cleanup()
{
    echo "#### Trapped in getpylibs.sh Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

sudo pip install google-api-python-client \
gdcmdtools \

echo -e "\n *** Finished installing all Python Libs... ***"
