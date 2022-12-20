#!/usr/bin/env bash

clear

echo -n 'Starting the Cassandra-2 node ...'; 
timeout 60 bash -c 'until cqlsh localhost 9042 -e "describe cluster" >/dev/null 2>&1; do sleep 1; echo -n "."; done'
#sleep 2
timeout 60 bash -c 'until cqlsh localhost 9043 -e "describe cluster" >/dev/null 2>&1; do sleep 1; echo -n "."; done'
#sleep 2
#timeout 60 bash -c 'until ( cqlsh localhost 9042 -e "select count(*) as peers from system.peers;" | grep "(1 rows)" ) >/dev/null 2>&1; do sleep 1; echo -n "."; done'
#sleep 2

timeout 80 bash -c 'node_count=0; until [ $node_count -eq 2 ] >/dev/null 2>&1; do sleep 1; node_count=$( docker exec -i -t Cassandra-2 bash -c "nodetool status" | grep -e "UN" -c ); echo -n "."; done'

echo ' DONE!'
echo "Cassandra successfully started."

echo ""

sleep 2



      
