#!/usr/bin/env bash
set -e

if [ -z "$SUDO_USER" ]; then
CUSER=$USER
else
CUSER=$SUDO_USER
fi

echo '* Current user:' $CUSER

echo '* Creating ~/Workspace/devops'
mkdir -p ~/Workspace/devops/

echo
echo '* Creating data folders ...'
mkdir -p ~/Workspace/data/
mkdir -p ~/Workspace/data/logs/

chmod -R 777 ~/Workspace/data/
chown -R $CUSER:staff ~/Workspace/data/
