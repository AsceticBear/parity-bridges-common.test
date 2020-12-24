#!/bin/bash
. ./prelude.sh
. ./build-drml-node.sh

###############################################################################
### Song (Substrate) chain startup ##########################################
###############################################################################

# remove Song databases
rm -rf data/drml-alice.db
rm -rf data/drml-bob.db
rm -rf data/drml-charlie.db
rm -rf data/drml-dave.db
rm -rf data/drml-eve.db

# start Song nodes
RUST_LOG=runtime=trace ./run-with-log.sh drml-alice "./bin/drml\
	--alice\
	--base-path=data/drml-alice.db\
	--bootnodes=/ip4/127.0.0.1/tcp/30334/p2p/12D3KooWSEpHJj29HEzgPFcRYVc5X3sEuP3KgiUoqJNCet51NiMX\
	--node-key=79cf382988364291a7968ae7825c01f68c50d679796a8983237d07fe0ccf363b\
	--port=30333\
	--prometheus-port=9615\
	--rpc-port=9933\
	--ws-port=9944\
	--execution=Native\
	--chain=dev\
	--rpc-cors=all\
	--unsafe-rpc-external\
	--unsafe-ws-external"&
# RUST_LOG=runtime=trace ./run-with-log.sh drml-bob "./bin/drml\
# 	--bob\
# 	--base-path=data/drml-bob.db\
# 	--bootnodes=/ip4/127.0.0.1/tcp/30333/p2p/12D3KooWMF6JvV319a7kJn5pqkKbhR3fcM2cvK5vCbYZHeQhYzFE\
# 	--node-key=4f9d0146dd9b7b3bf5a8089e3880023d1df92057f89e96e07bb4d8c2ead75bbd\
# 	--port=30334\
# 	--prometheus-port=9616\
# 	--rpc-port=9934\
# 	--ws-port=9945\
# 	--execution=Native\
# 	--chain=dev\
# 	--rpc-cors=all\
# 	--unsafe-rpc-external\
# 	--unsafe-ws-external"&
# RUST_LOG=runtime=trace ./run-with-log.sh drml-charlie "./bin/drml\
# 	--charlie\
# 	--base-path=data/drml-charlie.db\
# 	--bootnodes=/ip4/127.0.0.1/tcp/30333/p2p/12D3KooWMF6JvV319a7kJn5pqkKbhR3fcM2cvK5vCbYZHeQhYzFE\
# 	--port=30335\
# 	--prometheus-port=9617\
# 	--rpc-port=9935\
# 	--ws-port=9946\
# 	--execution=Native\
# 	--chain=dev\
# 	--rpc-cors=all\
# 	--unsafe-rpc-external\
# 	--unsafe-ws-external"&
# RUST_LOG=runtime=trace ./run-with-log.sh drml-dave "./bin/drml\
# 	--dave\
# 	--base-path=data/drml-dave.db\
# 	--bootnodes=/ip4/127.0.0.1/tcp/30333/p2p/12D3KooWMF6JvV319a7kJn5pqkKbhR3fcM2cvK5vCbYZHeQhYzFE\
# 	--port=30336\
# 	--prometheus-port=9618\
# 	--rpc-port=9936\
# 	--ws-port=9947\
# 	--execution=Native\
# 	--chain=dev\
# 	--rpc-cors=all\
# 	--unsafe-rpc-external\
# 	--unsafe-ws-external"&
# RUST_LOG=runtime=trace ./run-with-log.sh drml-eve "./bin/drml\
# 	--eve\
# 	--base-path=data/drml-eve.db\
# 	--bootnodes=/ip4/127.0.0.1/tcp/30333/p2p/12D3KooWMF6JvV319a7kJn5pqkKbhR3fcM2cvK5vCbYZHeQhYzFE\
# 	--port=30337\
# 	--prometheus-port=9619\
# 	--rpc-port=9937\
# 	--ws-port=9948\
# 	--execution=Native\
# 	--chain=dev\
# 	--rpc-cors=all\
# 	--unsafe-rpc-external\
# 	--unsafe-ws-external"&

###############################################################################
### Give nodes some time to startup ###########################################
###############################################################################
sleep 20