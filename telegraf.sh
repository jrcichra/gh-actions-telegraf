#!/bin/bash

### Clone this repo - https://github.com/jrcichra/gh-actions-telegraf-config
### Set $INFLUX_USERNAME and $INFLUX_PASSWORD in your github secrets
### Run this script

if [ -f "gh-actions-telegraf/telegraf.conf" ];then
    # Modify that config in place to put in the username and password for influx
    sed -i "s/###GITHUBACTIONSAUTH###/  username=\"${INFLUX_USERNAME}\"\n  password=\"${INFLUX_PASSWORD}\"/" "gh-actions-telegraf/telegraf.conf"
    # Do the same for the url
    sed -i "s/###GITHUBACTIONSURL###/  urls = [\"${INFLUX_URL}\"]/" "gh-actions-telegraf/telegraf.conf"
    # Print out the config for debugging
    cat "gh-actions-telegraf/telegraf.conf"
    # Run a copy of telegraf and point it to that config
    docker run --name=telegraf --hostname=$(hostname) --volume=/etc:/rootfs/etc:ro --volume=/proc:/host/proc:ro --volume=/var/run/docker.sock:/var/run/docker.sock:ro --volume=${PWD}/gh-actions-telegraf/telegraf.conf:/etc/telegraf/telegraf.conf:ro --volume=/sys:/rootfs/sys:ro --volume=/proc:/rootfs/proc:ro --network=host --privileged --restart=always --detach=true -t telegraf telegraf
    ## Show the logs to see if it was successful in connecting
    sleep 25
    docker logs telegraf
else
    echo "Could not find telegraf config file at gh-actions-telegraf/telegraf.conf"
fi
