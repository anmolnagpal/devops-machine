#!/usr/bin/env bash

docker build -t anmolnagpal/devops:1.8.0 .

if [[ $? != 0 ]]; then
    echo "DevOps Build failed."
    exit 1
fi

docker push anmolnagpal/devops:1.8.0
