#!/bin/bash
. ./prelude.sh

cargo build --release --manifest-path=$BRIDGES_REPO_PATH/bin/song/cli/Cargo.toml
cp $BRIDGES_REPO_PATH/target/release/song-node ./bin