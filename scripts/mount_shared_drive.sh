#!/bin/bash

if [ "$USER" != "root" ]
then
  echo "This script must be run with sudo: sudo ${0}"
  exit -1
fi

OSX_IP=$(ifconfig en0 | grep --word-regexp inet | awk '{print $2}')
MACHINE_NAME="dev"
B2D_IP=$(sudo cat ~/.docker/machine/machines/${MACHINE_NAME}/config.json | grep IPAddress | cut -d'"' -f4)
B2D_ETH0_IP=$(sudo -u ${SUDO_USER} docker-machine ssh ${MACHINE_NAME} ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

if [ "$B2D_IP" = 0 ] || [ "$B2D_IP" = "" ] || [ "$B2D_ETH0_IP" = 0 ] || [ "$B2D_ETH0_IP" = "" ]; then
    echo "Run or create the docker machine"
    exit 1
fi

B2D_NET="$(echo $B2D_IP | cut -d'.' -f1 -f2 -f3).1"

MAP_USER=${SUDO_USER}
MAP_GROUP=$(sudo -u ${SUDO_USER} id -n -g)
RESTART_NFSD=0
## todo optimize
USRDIR="/Users/${SUDO_USER}"
WKSDIR="/Users/${SUDO_USER}"

echo "
# BEGIN: docker-machine ${MACHINE_NAME}
${WKSDIR} -alldirs -mapall=${MAP_USER}:${MAP_GROUP}
# END: docker-machine ${MACHINE_NAME}
" > /etc/exports

NFSD_LINE="nfs.server.nfsd_threads = 9"
grep "$NFSD_LINE" /etc/nfs.conf > /dev/null
if [ "$?" != "0" ]
then
  RESTART_NFSD=1
  echo "
#
# nfs.conf: the NFS configuration file
#
nfs.server.bonjour = 0
nfs.server.mount.regular_files = 1
nfs.server.mount.require_resv_port = 0
nfs.server.nfsd_threads = 9
nfs.server.async = 1
" > /etc/nfs.conf
fi

if [ "$RESTART_NFSD" == "1" ]
then
  echo "Restarting nfsd"
  nfsd update 2> /dev/null || (nfsd restart && sleep 5)
fi

bootlocalCmd="
  #!/bin/bash
  sudo sysctl -w vm.max_map_count=262144
  echo 'Unmounting ${WKSDIR}'
  sudo umount -f ${WKSDIR} 2> /dev/null
  echo 'Starting nfs-client'
  sudo /usr/local/etc/init.d/nfs-client start 2> /dev/null
  echo 'Mounting ${WKSDIR}'
  sudo mkdir -p ${WKSDIR}
  sudo mount -t nfs -o rw,noacl,nocto,noatime,nodiratime,soft,nolock,rsize=32768,wsize=32768,intr,tcp,nfsvers=3,actimeo=2 $B2D_NET:${WKSDIR} ${WKSDIR}
  echo 'Mounted ${WKSDIR}:'
  ls -x ${WKSDIR}
  # tce-load -wi sshfs-fuse
  sudo killall -9 ntpd
  sudo ntpclient -s -h pool.ntp.org
  sudo ntpd -p pool.ntp.org
  date
"

filePath="/var/lib/boot2docker/bootlocal.sh"
sudo -u ${SUDO_USER} docker-machine ssh ${MACHINE_NAME} "echo '$bootlocalCmd' | sudo tee $filePath && sudo chmod +x $filePath && sync" > /dev/null

echo "bootlocal.sh copied to ${MACHINE_NAME}"

sudo -u ${SUDO_USER} docker-machine ssh ${MACHINE_NAME} "sudo sh /var/lib/boot2docker/bootlocal.sh"

#sudo -u ${SUDO_USER} docker-machine ssh ${MACHINE_NAME} sudo cat /var/lib/boot2docker/profile

#echo "Restart the machine docker-machine restart ${MACHINE_NAME}"
