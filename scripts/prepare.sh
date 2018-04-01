#!/usr/bin/env bash

if [ "$USER" != "root" ]
then
  echo "This script must be run with sudo: sudo ${0}"
  exit -1
fi

if [ -z "$SUDO_USER" ]; then
CUSER=$USER
else
CUSER=$SUDO_USER
fi
export CUSER=$CUSER

sudo chmod -R 777 ~/.docker/machine/machines/*/config.json

DEVIP=$(cat ~/.docker/machine/machines/dev/config.json | grep IPAddress | cut -d'"' -f4)
if [ "$DEVIP" = 0 ] || [ "$DEVIP" = "" ]; then
    echo "Run or create the docker machine"
    exit 1
fi

chmod -R +x */*.sh
chmod -R +x */*/*.sh
my_dir="$(dirname "$0")"

PY=`which python`
$PY $my_dir/tasks.py github
#$PY $my_dir/tasks.py
echo
"$my_dir/misc.sh"
echo
"$my_dir/update_hosts.sh"
echo
"$my_dir/mount_shared_drive.sh"
echo
