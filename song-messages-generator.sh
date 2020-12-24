#!/bin/bash

# THIS SCRIPT IS NOT INTENDED FOR USE IN PRODUCTION ENVIRONMENT
#
# This scripts periodically calls relay binary to generate Song -> Tang
# messages.

set -eu

# Path to relay binary
RELAY_BINARY_PATH=./bin/substrate-relay
# Song node host
SONG_HOST=127.0.0.1
# Song node port
SONG_PORT=9946
# Song signer
SONG_SIGNER=//Dave
# Tang signer
TANG_SIGNER=//Dave
# Max delay before submitting transactions (s)
MAX_SUBMIT_DELAY_S=60
# Lane to send message over
LANE=00000000

while true
do
	# sleep some time
	SUBMIT_DELAY_S=`shuf -i 0-$MAX_SUBMIT_DELAY_S -n 1`
	echo "Sleeping $SUBMIT_DELAY_S seconds..."
	sleep $SUBMIT_DELAY_S

	# prepare message to send
	MESSAGE=Remark

	# prepare fee to pay
	FEE=10000000000

	# submit message
	echo "Sending message from Song to Tang"
	$RELAY_BINARY_PATH 2>&1 submit-song-to-tang-message \
		--song-host=$SONG_HOST\
		--song-port=$SONG_PORT\
		--song-signer=$SONG_SIGNER\
		--tang-signer=$TANG_SIGNER\
		--lane=$LANE\
		--message=$MESSAGE\
		--fee=$FEE
done
