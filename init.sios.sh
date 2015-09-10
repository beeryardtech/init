##
# @name initsios.sh
# @description
##
cleanup()
{
    echo "#### Trapped in $( basename '$0' ). Exiting."
    exit 255
}
trap cleanup SIGINT SIGTERM

read -r -d '' USAGE << "EOF"
Inits everything to do with SIOS Tech environment.

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

# SIOS Tech mount points
sudo mkdir -p /export/{filepile,nobackups,PKGS,public}
sudo chmod -r 755 /export

# Add this to fstab
read -d '' fstabStr << "EOF"

hancock.sc.steeleye.com:/filepile       /export/filepile     nfs     rsize=8192,wsize=8192,timeo=14,intr
hancock.sc.steeleye.com:/nobackups      /export/nobackups    nfs     rsize=8192,wsize=8192,timeo=14,intr
fenric.sc.steeleye.com:/export/PKGS     /export/PKGS         nfs     defaults 0 0
fenric.sc.steeleye.com:/export/public   /export/public       nfs     defaults 0 0
EOF

# Concat to the end of the fstab file
echo $fstabStr | sudo tee -a /etc/fstab

udo mount -a
