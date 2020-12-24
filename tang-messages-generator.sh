#!/bin/bash

# THIS SCRIPT IS NOT INTENDED FOR USE IN PRODUCTION ENVIRONMENT
#
# This scripts periodically calls relay binary to generate Tang -> Song
# messages.

set -eu

# Path to relay binary
RELAY_BINARY_PATH=./bin/substrate-relay
# Tang node host
TANG_HOST=127.0.0.1
# Tang node port
TANG_PORT=10946
# Tang signer
TANG_SIGNER=//Dave
# Song signer
SONG_SIGNER=//Dave
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
	FEE=100000000

	# submit message
	echo "Sending message from Tang to Song"
	$RELAY_BINARY_PATH 2>&1 submit-tang-to-song-message \
		--tang-host=$TANG_HOST\
		--tang-port=$TANG_PORT\
		--tang-signer=$TANG_SIGNER\
		--song-signer=$SONG_SIGNER\
		--lane=$LANE\
		--message=$MESSAGE\
		--fee=$FEE
done
