#!/bin/bash
#original file from https://github.com/joanmarcriera/pisces-scripts/blob/d87a9441b839cb48db5b56dfe072d994b4107290/troubleshooting/check.sh
DOCKER_NAME=$(docker ps | grep miner:miner | awk 'NF>1{print $NF}')

echo "==== Is the disk full?==="
df -HPT

echo "======CHECKS START======"
echo "Hostname = > $(hostname)"
echo "Uptime   = > $(uptime)"
echo "Docker ps => $(docker ps)"
echo "Public IP => $(curl -s ifconfig.me)"

echo "========SYNC HEIGHT======"
source ./get-height.sh

echo "======MINER INFO SUMMARY===="
docker exec $DOCKER_NAME miner info summary

echo "========PEER BOOKS======"
docker exec $DOCKER_NAME miner peer book -s

echo "===== CHECKS END ======"
