#!/bin/bash
. ./prelude.sh

cargo build --release --manifest-path=$BRIDGES_REPO_PATH/bin/node/cli/Cargo.toml
cp $BRIDGES_REPO_PATH/target/release/drml ./bin