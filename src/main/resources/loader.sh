#!/usr/bin/env bash

echo "creating cassandra readmodel data ..."
cd /etc/cassandra/cqls
keyspaces=("akka" "akka_snapshot")
for keyspace in "${keyspaces[@]}"; do
  cqlsh -f "${keyspace}-schema.cql"
  cqlsh -f "export-cassandra-${keyspace}-tables.cql"
done


echo "creating cassandra readmodel data DONE ..."
