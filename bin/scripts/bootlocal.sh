
#!/usr/bin/env bash
echo $localIp
echo
#mount | grep nfs > /dev/null && \
#  echo "/Users already mounted with NFS" && \
#  exit
sudo mkdir -p /Users
echo "Unmounting /Users"
sudo umount /Users 2> /dev/null
echo "Starting nfs-client"
sudo /usr/local/etc/init.d/nfs-client start 2> /dev/null
echo "Mounting /Users"
sudo mount -t nfs $localIp:/Users /Users -o noacl,async,noatime,soft,nolock,vers=3,udp,proto=udp,rsize=8192,wsize=8192,namlen=255,timeo=10,retrans=3,nfsvers=3
echo "Mounted /Users:"
