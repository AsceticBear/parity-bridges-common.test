###############################################################################
### Starting Prometheus + Grafana #############################################
###############################################################################

# copy common files requires for dashboard
rm -rf data/dashboards
mkdir -p data/dashboards
cp -rf dashboards/grafana-dashboard.yaml data/dashboards
cp -rf dashboards/grafana-datasource.yaml data/dashboards
cp -rf dashboards/prometheus.yml data/dashboards

# prepare Song-PoA -> Song headers relay dashboard
cp -rf dashboards/relay-headers-dashboard.json data/dashboards/relay-eth2sub-dashboard.json
sed -i 's/{SOURCE_NAME}/Ethereum/g' data/dashboards/relay-eth2sub-dashboard.json
sed -i 's/{TARGET_NAME}/Substrate/g' data/dashboards/relay-eth2sub-dashboard.json
sed -i 's/{BRIDGE_ID}/relay-eth2sub/g' data/dashboards/relay-eth2sub-dashboard.json
sed -i 's/{BRIDGE_NAME}/eth2sub/g' data/dashboards/relay-eth2sub-dashboard.json

# prepare Song -> Song-PoA headers relay dashboard
cp -rf dashboards/relay-headers-dashboard.json data/dashboards/relay-sub2eth-dashboard.json
sed -i 's/{SOURCE_NAME}/Substrate/g' data/dashboards/relay-sub2eth-dashboard.json
sed -i 's/{TARGET_NAME}/Ethereum/g' data/dashboards/relay-sub2eth-dashboard.json
sed -i 's/{BRIDGE_ID}/relay-sub2eth/g' data/dashboards/relay-sub2eth-dashboard.json
sed -i 's/{BRIDGE_NAME}/sub2eth/g' data/dashboards/relay-sub2eth-dashboard.json

# prepare Song-PoA -> Song exchange relay dashboard
cp -rf dashboards/relay-exchange-dashboard.json data/dashboards/relay-eth2sub-exchange-dashboard.json
sed -i 's/{SOURCE_NAME}/Ethereum/g' data/dashboards/relay-eth2sub-exchange-dashboard.json
sed -i 's/{TARGET_NAME}/Substrate/g' data/dashboards/relay-eth2sub-exchange-dashboard.json
sed -i 's/{BRIDGE_ID}/eth2sub-exchange/g' data/dashboards/relay-eth2sub-exchange-dashboard.json

# prepare Song -> Tang headers relay dashboard
cp -rf dashboards/relay-headers-dashboard.json data/dashboards/relay-song2tang-node-dashboard.json
sed -i 's/{SOURCE_NAME}/Song/g' data/dashboards/relay-song2tang-node-dashboard.json
sed -i 's/{TARGET_NAME}/Tang/g' data/dashboards/relay-song2tang-node-dashboard.json
sed -i 's/{BRIDGE_ID}/relay-song2tang-node/g' data/dashboards/relay-song2tang-node-dashboard.json
sed -i 's/{BRIDGE_NAME}/song2tang-node/g' data/dashboards/relay-song2tang-node-dashboard.json

# prepare Tang -> Song headers relay dashboard
cp -rf dashboards/relay-headers-dashboard.json data/dashboards/relay-tang-node2song-dashboard.json
sed -i 's/{SOURCE_NAME}/Tang/g' data/dashboards/relay-tang-node2song-dashboard.json
sed -i 's/{TARGET_NAME}/Song/g' data/dashboards/relay-tang-node2song-dashboard.json
sed -i 's/{BRIDGE_ID}/relay-tang-node2song/g' data/dashboards/relay-tang-node2song-dashboard.json
sed -i 's/{BRIDGE_NAME}/tang-node2song/g' data/dashboards/relay-tang-node2song-dashboard.json

# prepare Tang -> Song messages relay dashboard (lane 00000000)
cp -rf dashboards/relay-messages-dashboard.json data/dashboards/relay-tang-node2song-messages-00000000-dashboard.json
sed -i 's/{SOURCE_NAME}/Tang/g' data/dashboards/relay-tang-node2song-messages-00000000-dashboard.json
sed -i 's/{TARGET_NAME}/Song/g' data/dashboards/relay-tang-node2song-messages-00000000-dashboard.json
sed -i 's/{LANE_ID}/00000000/g' data/dashboards/relay-tang-node2song-messages-00000000-dashboard.json
sed -i 's/{BRIDGE_ID}/relay-tang-node2song-messages-00000000/g' data/dashboards/relay-tang-node2song-messages-00000000-dashboard.json
sed -i 's/{BRIDGE_NAME}/tang-node2song-messages-00000000/g' data/dashboards/relay-tang-node2song-messages-00000000-dashboard.json

# prepare Song -> Tang messages relay dashboard (lane 00000000)
cp -rf dashboards/relay-messages-dashboard.json data/dashboards/relay-song2tang-node-messages-00000000-dashboard.json
sed -i 's/{SOURCE_NAME}/Song/g' data/dashboards/relay-song2tang-node-messages-00000000-dashboard.json
sed -i 's/{TARGET_NAME}/Tang/g' data/dashboards/relay-song2tang-node-messages-00000000-dashboard.json
sed -i 's/{LANE_ID}/00000000/g' data/dashboards/relay-song2tang-node-messages-00000000-dashboard.json
sed -i 's/{BRIDGE_ID}/relay-song2tang-node-messages-00000000/g' data/dashboards/relay-song2tang-node-messages-00000000-dashboard.json
sed -i 's/{BRIDGE_NAME}/song2tang-node-messages-00000000/g' data/dashboards/relay-song2tang-node-messages-00000000-dashboard.json

# run prometheus (http://127.0.0.1:9090/)
docker container rm relay-prometheus | true
docker run \
	--name=relay-prometheus \
	--network=host \
	-v `realpath data/dashboards/prometheus.yml`:/etc/prometheus/prometheus.yml \
	prom/prometheus \
	--config.file /etc/prometheus/prometheus.yml&

# run grafana (http://127.0.0.1:3000/ + admin/admin)
docker container rm relay-grafana | true
docker run \
	--name=relay-grafana \
	--network=host \
	-v `realpath data/dashboards/grafana-datasource.yaml`:/etc/grafana/provisioning/datasources/grafana-datasource.yaml \
	-v `realpath data/dashboards/grafana-dashboard.yaml`:/etc/grafana/provisioning/dashboards/grafana-dashboard.yaml \
	-v `realpath data/dashboards/relay-eth2sub-dashboard.json`:/etc/grafana/provisioning/dashboards/relay-eth2sub-dashboard.json \
	-v `realpath data/dashboards/relay-sub2eth-dashboard.json`:/etc/grafana/provisioning/dashboards/relay-sub2eth-dashboard.json \
	-v `realpath data/dashboards/relay-eth2sub-exchange-dashboard.json`:/etc/grafana/provisioning/dashboards/relay-eth2sub-exchange-dashboard.json \
	-v `realpath data/dashboards/relay-song2tang-node-dashboard.json`:/etc/grafana/provisioning/dashboards/relay-song2tang-node-dashboard.json \
	-v `realpath data/dashboards/relay-tang-node2song-dashboard.json`:/etc/grafana/provisioning/dashboards/relay-tang-node2song-dashboard.json \
	-v `realpath data/dashboards/relay-tang-node2song-messages-00000000-dashboard.json`:/etc/grafana/provisioning/dashboards/relay-tang-node2song-messages-00000000-dashboard.json \
	-v `realpath data/dashboards/relay-song2tang-node-messages-00000000-dashboard.json`:/etc/grafana/provisioning/dashboards/relay-song2tang-node-messages-00000000-dashboard.json \
	-v `realpath data/dashboards/my.json`:/etc/grafana/provisioning/dashboards/my.json \
	grafana/grafana&
