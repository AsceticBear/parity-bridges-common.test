#!/bin/bash

. ./prelude.sh
. ./build-tang-node.sh
. ./build-song-node.sh
. ./build-substrate-relay.sh

bash ./start-song.sh
bash ./start-tang.sh
# bash ./start-dashboards.sh
