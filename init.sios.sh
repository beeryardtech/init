##
# @name initsios.sh
# @description
# Inits everything to do with SIOS Tech environment.
##

# Only should be ran as root
if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root" 1>&2
    exit 1
fi
cleanup()
{
    echo "#### Trapped in installs.sh. Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

wget -qO - http://repo.sc.steeleye.com/sios_dev_signing_key.asc | sudo apt-key add -
# Search if source.list has repo already in it

# If not append to list
echo -e "\n deb http://repo.sc.steeleye.com/ everest main" | sudo tee /etc/apt/sources.list.d/sios.list

# Go get the stuff
sudo apt-get update && sudo apt-get install cloud-orchestrator cloud-orchestrator--ui

# Fixes issue with tomcat7 on Ubuntu 14.04 (trusty)
sudo touch /etc/authbind/byport/80
sudo chmod 500 /etc/authbind/byport/80
sudo chown tomcat7 /etc/authbind/byport/

# SIOS Tech mount points
sudo mkdir -p /export/{filepile,nobackups,PKGS,public}

sudo chmod 755 /export

# Add this to fstab
read -d '' fstabStr << "EOF"
hancock.sc.steeleye.com:/filepile       /export/filepile     nfs     rsize=8192,wsize=8192,timeo=14,intr
hancock.sc.steeleye.com:/nobackups      /export/nobackups    nfs     rsize=8192,wsize=8192,timeo=14,intr
fenric.sc.steeleye.com:/export/PKGS     /export/PKGS         nfs     defaults 0 0
fenric.sc.steeleye.com:/export/public   /export/public       nfs     defaults 0 0
EOF

# Concat to the end of the fstab file
echo $fstabStr | sudo tee -a /etc/fstab

sudo mount -a

# Install the printer driver
sudo dpkg -i /export/filepile/software/printer/Canon2225/g12b3eng_lindeb32_0204.deb
