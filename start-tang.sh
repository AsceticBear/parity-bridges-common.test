#!/bin/bash
. ./prelude.sh
. ./build-tang-node.sh

###############################################################################
### Tang (Substrate) chain startup ##########################################
###############################################################################

# TODO: Tang should use other authorities && other session management

# remove Tang databases
rm -rf data/tang-alice.db
rm -rf data/tang-bob.db
rm -rf data/tang-charlie.db
rm -rf data/tang-dave.db
rm -rf data/tang-eve.db

# start Tang nodes
RUST_LOG=runtime=trace ./run-with-log.sh tang-alice "./bin/tang-node\
	--alice\
	--base-path=data/tang-alice.db\
	--bootnodes=/ip4/127.0.0.1/tcp/40334/p2p/12D3KooWM5LFR5ne4yTQ4sBSXJ75M4bDo2MAhAW2GhL3i8fe5aRb\
	--node-key=0f900c89f4e626f4a217302ab8c7d213737d00627115f318ad6fb169717ac8e0\
	--port=40333\
	--prometheus-port=10615\
	--rpc-port=10933\
	--ws-port=10944\
	--execution=Native\
	--chain=dev\
	--rpc-cors=all\
	--unsafe-rpc-external\
	--unsafe-ws-external"&
RUST_LOG=runtime=trace ./run-with-log.sh tang-bob "./bin/tang-node\
	--bob\
	--base-path=data/tang-bob.db\
	--bootnodes=/ip4/127.0.0.1/tcp/40333/p2p/12D3KooWFqiV73ipQ1jpfVmCfLqBCp8G9PLH3zPkY9EhmdrSGA4H\
	--node-key=db383639ff2905d79f8e936fd5dc4416ef46b514b2f83823ec3c42753d7557bb\
	--port=40334\
	--prometheus-port=10616\
	--rpc-port=10934\
	--ws-port=10945\
	--execution=Native\
	--chain=dev\
	--rpc-cors=all\
	--unsafe-rpc-external\
	--unsafe-ws-external"&
RUST_LOG=runtime=trace ./run-with-log.sh tang-charlie "./bin/tang-node\
	--charlie\
	--base-path=data/tang-charlie.db\
	--bootnodes=/ip4/127.0.0.1/tcp/40333/p2p/12D3KooWFqiV73ipQ1jpfVmCfLqBCp8G9PLH3zPkY9EhmdrSGA4H\
	--port=40335\
	--prometheus-port=10617\
	--rpc-port=10935\
	--ws-port=10946\
	--execution=Native\
	--chain=dev\
	--rpc-cors=all\
	--unsafe-rpc-external\
	--unsafe-ws-external"&
RUST_LOG=runtime=trace ./run-with-log.sh tang-dave "./bin/tang-node\
	--dave\
	--base-path=data/tang-dave.db\
	--bootnodes=/ip4/127.0.0.1/tcp/40333/p2p/12D3KooWFqiV73ipQ1jpfVmCfLqBCp8G9PLH3zPkY9EhmdrSGA4H\
	--port=40336\
	--prometheus-port=10618\
	--rpc-port=10936\
	--ws-port=10947\
	--execution=Native\
	--chain=dev\
	--rpc-cors=all\
	--unsafe-rpc-external\
	--unsafe-ws-external"&
RUST_LOG=runtime=trace ./run-with-log.sh tang-eve "./bin/tang-node\
	--eve\
	--base-path=data/tang-eve.db\
	--bootnodes=/ip4/127.0.0.1/tcp/40333/p2p/12D3KooWFqiV73ipQ1jpfVmCfLqBCp8G9PLH3zPkY9EhmdrSGA4H\
	--port=40337\
	--prometheus-port=10619\
	--rpc-port=10937\
	--ws-port=10948\
	--execution=Native\
	--chain=dev\
	--rpc-cors=all\
	--unsafe-rpc-external\
	--unsafe-ws-external"&

###############################################################################
### Give nodes some time to startup ###########################################
###############################################################################
sleep 20

###############################################################################
### Initialize header bridges #################################################
###############################################################################

# common variables
TANG_HOST=127.0.0.1
TANG_PORT=10944
SONG_HOST=127.0.0.1
SONG_PORT=9944
RELAY_BINARY_PATH=./bin/substrate-relay
RUST_LOG=bridge=trace,runtime=trace,bridge-metrics=info
export TANG_HOST TANG_PORT SONG_HOST SONG_PORT RELAY_BINARY_PATH RUST_LOG

# initialize Tang -> Song headers bridge
# ./run-with-log.sh initialize-tang-to-song "./bin/substrate-relay\
# 	initialize-tang-headers-bridge-in-song\
# 	--tang-host=$TANG_HOST\
# 	--tang-port=$TANG_PORT\
# 	--song-host=$SONG_HOST\
# 	--song-port=$SONG_PORT\
# 	--song-signer=//Alice"&

# initialize Song -> Tang headers bridge
./run-with-log.sh initialize-song-to-tang "./bin/substrate-relay\
	initialize-song-headers-bridge-in-tang\
	--song-host=$SONG_HOST\
	--song-port=$SONG_PORT\
	--tang-host=$TANG_HOST\
	--tang-port=$TANG_PORT\
	--tang-signer=//Alice"&

# # wait until transactions are mined
sleep 10

###############################################################################
### Start generating messages on Tang <-> Song lanes ######################
###############################################################################

# start generating Tang -> Song messages
# ./run-with-log.sh \
# 	tang-to-song-messages-generator\
# 	./tang-messages-generator.sh&

# start generating Song -> Tang messages
./run-with-log.sh \
	song-to-tang-messages-generator\
	./song-messages-generator.sh&

# ###############################################################################
# ### Starting Tang -> Song relays ##########################################
# ###############################################################################

# start tang-headers-to-song relay
# ./run-with-log.sh relay-tang-to-song "./bin/substrate-relay\
# 	tang-headers-to-song\
# 	--tang-host=$TANG_HOST\
# 	--tang-port=$TANG_PORT\
# 	--song-host=$SONG_HOST\
# 	--song-port=$SONG_PORT\
# 	--song-signer=//Charlie\
# 	--prometheus-port=9700"&

# # start song-headers-to-tang relay
./run-with-log.sh relay-song-to-tang "./bin/substrate-relay\
	song-headers-to-tang\
	--song-host=$SONG_HOST\
	--song-port=$SONG_PORT\
	--tang-host=$TANG_HOST\
	--tang-port=$TANG_PORT\
	--tang-signer=//Charlie\
	--prometheus-port=9701"&

# # start tang-messages-to-song relay
# ./run-with-log.sh relay-tang-to-song-messages "./bin/substrate-relay\
# 	tang-messages-to-song\
# 	--tang-host=$TANG_HOST\
# 	--tang-port=$TANG_PORT\
# 	--tang-signer=//Eve\
# 	--song-host=$SONG_HOST\
# 	--song-port=$SONG_PORT\
# 	--song-signer=//Eve\
# 	--prometheus-port=9702\
# 	--lane=00000000"&

# # start song-messages-to-tang relay
./run-with-log.sh relay-song-to-tang-messages "./bin/substrate-relay\
	song-messages-to-tang\
	--song-host=$SONG_HOST\
	--song-port=$SONG_PORT\
	--song-signer=//Ferdie\
	--tang-host=$TANG_HOST\
	--tang-port=$TANG_PORT\
	--tang-signer=//Ferdie\
	--prometheus-port=9703\
	--lane=00000000"&
