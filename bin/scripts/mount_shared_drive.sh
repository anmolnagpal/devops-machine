#!/bin/bash

#
# This script will mount /Users in the boot2docker VM using NFS (instead of the
# default vboxsf). It's probably not a good idea to run it while there are
# Docker containers running in boot2docker.
#
# Usage: sudo ./boot2docker-use-nfs.sh
#



if [ "$USER" != "root" ]
then
  echo "This script must be run with sudo: sudo ${0}"
  exit -1
fi

# Run command as non root http://stackoverflow.com/a/10220200/96855
B2D_IP=$(sudo -u ${SUDO_USER} docker-machine ip dev &> /dev/null)

if [ "$?" != "0" ]
then
  sudo -u ${SUDO_USER} docker-machine start dev
  eval "$(sudo -u ${SUDO_USER} docker-machine env dev)"
  B2D_IP=$(sudo -u ${SUDO_USER} docker-machine ip dev &> /dev/null)
  #echo "You need to start boot2docker first: boot2docker up && \$(boot2docker shellinit) "
  #exit -1
fi


MAP_USER=${SUDO_USER}
MAP_GROUP=$(sudo -u ${SUDO_USER} id -n -g)
RESTART_NFSD=0


#EXPORTS_LINE="/Users -alldirs,quiet -mapall=${MAP_USER}:${MAP_GROUP} ${OSX_IP}"
EXPORTS_LINE="/Users -alldirs,quiet -mapall=${MAP_USER}:${MAP_GROUP} -network 192.168.99.0 -mask 255.255.255.0"
grep "$EXPORTS_LINE" /etc/exports > /dev/null
if [ "$?" != "0" ]
then
  RESTART_NFSD=1
  # Backup exports file
  $(cp -n /etc/exports /etc/exports.bak) && \
    echo "Backed up /etc/exports to /etc/exports.bak"
  # Delete previously generated line if it exists
  grep -v '^/Users ' /etc/exports > /etc/exports
  # We are using the OS X IP because the b2d VM is behind NAT
  echo "$EXPORTS_LINE" >> /etc/exports
fi

NFSD_LINE="nfs.server.mount.require_resv_port = 0"
grep "$NFSD_LINE" /etc/nfs.conf > /dev/null
if [ "$?" != "0" ]
then
  RESTART_NFSD=1
  # Backup /etc/nfs.conf file
  $(cp -n /etc/nfs.conf /etc/nfs.conf.bak) && \
      echo "Backed up /etc/nfs.conf to /etc/nfs.conf.bak"
  echo "nfs.server.mount.require_resv_port = 0" >> /etc/nfs.conf
fi

if [ "$RESTART_NFSD" == "1" ]
then
  echo "Restarting nfsd"
  nfsd update 2> /dev/null || (nfsd restart && sleep 5)
fi

#my_dir="$(dirname "$0")"
#bootlocal=`cat $my_dir/bootlocal.sh`;

#sudo -u ${SUDO_USER} docker-machine ssh dev "echo -e '#!/bin/sh\nlocalIp='$localIp'$bootlocal' | sudo tee /var/lib/boot2docker/bootlocal.sh"
#sudo -u ${SUDO_USER} docker-machine ssh dev "sudo chmod +x /var/lib/boot2docker/bootlocal.sh"

echo $localIp
echo
#OSX_IP=$(ifconfig en0 | grep --word-regexp inet | awk '{print $2}')
localIp=$(
cat << EOF
`sudo -u ${SUDO_USER} docker-machine ssh dev ifconfig docker0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
EOF
)
localIp=192.168.99.1

bootlocalCmd=$(cat << EOF
  #!/bin/bash
  echo "Unmounting /Users"
  sudo umount -f /Users 2> /dev/null
  echo "Starting nfs-client"
  sudo /usr/local/etc/init.d/nfs-client start 2> /dev/null
  echo "Mounting /Users"
  sudo mount -t nfs $localIp:/Users /Users -o noacl,async,noatime,soft,nolock,vers=3,udp,proto=udp,rsize=8192,wsize=8192,namlen=255,timeo=10,retrans=3,nfsvers=3
  echo "Mounted /Users:"
  ls -al /Users
EOF
)

sudo -u ${SUDO_USER} docker-machine ssh dev <<  EOF
$bootlocalCmd
EOF


#echo "Restart the machine docker-machine restart dev"
