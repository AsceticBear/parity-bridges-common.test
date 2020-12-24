#!/bin/bash
. ./prelude.sh

cargo build --release --manifest-path=$BRIDGES_REPO_PATH/relayers/substrate/Cargo.toml
cp $BRIDGES_REPO_PATH/target/release/substrate-relay ./bin