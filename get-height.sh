#!/bin/bash
#original file from https://github.com/Doginal/helium-network-scripts/blob/4a4c2b0b2f0df650cd0bbd208ddcedb0c915b568/get-height.sh
#modified to grab the docker name so no input is required
#https://stackoverflow.com/questions/16616975/how-do-i-get-the-last-word-in-each-line-with-bash
#colors -> https://gist.github.com/abritinthebay/d80eb99b2726c83feb0d97eab95206c4

DOCKER_NAME=$(docker ps | grep helium/miner | awk 'NF>1{print $NF}')
CURRENT=$(($(curl --silent https://api.helium.io/v1/blocks/height -q | jq '.data.height')+0 ))
MINER=$(($(docker exec $DOCKER_NAME miner info height | cut -f 3)+0 ))
BEHIND=$(( $CURRENT - $MINER ))
PBEHIND=$(bc <<< "scale=4; $MINER/$CURRENT*100")
if [ $BEHIND -le 0 ];
then
        printf "\x1b[32mIn sync (or ahead): %i blocks\x1b[0m\n" $BEHIND
elif [[ $BEHIND -gt 0 && $BEHIND -le 20 ]];
then
        printf "\x1b[33mBehind by: %i block(s)\x1b[0m\n" $BEHIND
elif [ $BEHIND -gt 20 ];
then
        printf "\x1b[31mBehind by: %i block(s)\x1b[0m\n" $BEHIND
fi
printf "Miner: %i (%.2f%%)\n" $MINER $PBEHIND
printf "Helium Network Height: %i\n" $CURRENT
