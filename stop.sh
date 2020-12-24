#!/bin/bash

killall -9 parity
killall -9 tang-node
killall -9 song-node
killall -9 drml
killall -9 ethereum-poa-relay
killall -9 substrate-relay
kill -9 `ps -A -o pid,args -C bash | awk '/poa-exchange-tx-generator-entrypoint.sh/ { print $1 }' | head -n 1`
kill -9 `ps -A -o pid,args -C bash | awk '/tang-messages-generator.sh/ { print $1 }' | head -n 1`
kill -9 `ps -A -o pid,args -C bash | awk '/song-messages-generator.sh/ { print $1 }' | head -n 1`
docker stop relay-prometheus
docker stop relay-grafana