#!/usr/bin/env bash
set -e

if [ -z "$SUDO_USER" ]; then
CUSER=$USER
else
CUSER=$SUDO_USER
fi

echo '* Current user:' $CUSER

sudo chmod -R 777 ~/.docker/machine/machines/dev/config.json

