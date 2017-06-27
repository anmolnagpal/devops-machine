#!/usr/bin/env bash

chmod +x bin/*/*.sh

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

my_dir="$(dirname "$0")"

"$my_dir/bin/scripts/create_dir.sh"
"$my_dir/bin/scripts/mount_shared_drive.sh"


touch "$my_dir/gitconfig.conf"
