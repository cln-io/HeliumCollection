#!/bin/bash
#original file from https://github.com/Doginal/helium-network-scripts/blob/4a4c2b0b2f0df650cd0bbd208ddcedb0c915b568/get-height.sh
#modified to grab the docker name so no input is required

DOCKER_NAME=$(docker ps | grep miner:miner | awk '{print $10}')
CURRENT=$(($(curl --silent https://api.helium.io/v1/blocks/height -q | jq '.data.height')+0 ))
MINER=$(($(docker exec $DOCKER_NAME miner info height | cut -f 3)+0 ))
BEHIND=$(( $CURRENT - $MINER ))
PBEHIND=$(bc <<< "scale=2; $MINER/$CURRENT*100")
echo "Behind by: $BEHIND blocks"
echo "Miner: $MINER ($PBEHIND%)"
echo "Current Height: $CURRENT"
