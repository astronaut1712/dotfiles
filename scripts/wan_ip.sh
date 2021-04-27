#!/bin/bash
WAN_IP=$(cat $HOME/.wan_ip)
if [[ -z $WAN_IP ]]; then
    export WAN_IP=$(curl https://ipinfo.io -sS |jq -r '.ip')
    echo $WAN_IP > $HOME/.wan_ip
fi

echo $WAN_IP
