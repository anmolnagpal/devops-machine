#!/usr/bin/env bash
#set -e

if [ "$USER" = "root" ]
then
  echo "This script must be run with normal user"
  exit -1
fi

if [ -z "$SUDO_USER" ]; then
CUSER=$USER
else
CUSER=$SUDO_USER
fi
export CUSER=$CUSER

function suCuser {
    su - CUSER -c "$1"
}

# remove old docker installation if exists
rm /usr/local/bin/docker
rm /usr/local/bin/docker-compose
rm /usr/local/bin/docker-machine

#remove hosts fil
rm /Users/${CUSER}/.ssh/known_hosts

# install docker via brew
brew upgrade docker || brew install docker
brew upgrade docker-machine || brew install docker-machine
brew upgrade docker-compose || brew install docker-compose
brew upgrade docker-clean || brew install docker-clean
brew unlink docker ; brew link --overwrite docker
brew unlink docker-machine ; brew link --overwrite docker-machine
brew unlink docker-compose ; brew link --overwrite docker-compose
brew cleanup


#sudo -u ${SUDO_USER}  docker-machine upgrade dev
eval $(docker-machine env dev)
docker-clean
docker system prune --volumes -f
