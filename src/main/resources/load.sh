#!/usr/bin/env bash


echo "########## loading cassandra basic data"

CASSANDRA_CONT_ID=$(docker inspect -f '{{.Id}}' cassandra)

echo "using container $CASSANDRA_CONT_ID"

echo ">>>>>>>>> copying export scripts"
docker exec -it ${CASSANDRA_CONT_ID} rm -r /etc/cassandra/cqls
docker cp ./cqls ${CASSANDRA_CONT_ID}:/etc/cassandra/cqls
docker cp ./cqls/akka-schema.cql ${CASSANDRA_CONT_ID}:/etc/cassandra/cqls/
docker cp ./cqls/akka_snapshot-schema.cql ${CASSANDRA_CONT_ID}:/etc/cassandra/cqls/
docker cp loader.sh ${CASSANDRA_CONT_ID}:/etc/cassandra/cqls

echo ">>>>>>>>> executing scripts"

docker exec -it ${CASSANDRA_CONT_ID} chmod 777 /etc/cassandra/cqls/loader.sh

docker exec -it ${CASSANDRA_CONT_ID} /etc/cassandra/cqls/loader.sh

echo ">>>>>>>>> DONE CASSANDRA EXPORT"