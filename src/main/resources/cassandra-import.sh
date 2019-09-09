#!/usr/bin/env bash

# declare function
CASSANDRA_CONT_ID=$(docker inspect -f '{{.Id}}' cassandra)
export_cassandra_keyspace() {
  schema_name=$1 #readtables
  filename="${schema_name}-tables.cql"
  export_filename="export-cassandra-${schema_name}-tables.cql"
  import_filename="import-cassandra-${schema_name}-tables.cql"
  rm -r -f cqls/$schema_name
  rm -f $filename "./cqls/${export_filename}" ./cqls/$import_filename #remove files if exists
  echo "########## loading cassandra tables of ${schema_name}"
  echo "using container $CASSANDRA_CONT_ID"
  echo ">>>>>>>>> copying export scripts"
  docker exec -it ${CASSANDRA_CONT_ID} sh -c "cqlsh -k ${schema_name} -e 'DESC TABLES;' > ${filename}"
  docker cp ${CASSANDRA_CONT_ID}:$filename ./$filename
  docker exec -it ${CASSANDRA_CONT_ID} sh -c "rm ${filename}"
  while read -r line; do
    # Reading each line
    read -ra ADDR <<<$line # line is read into an array as tokens separated by IFS
    for i in "${ADDR[@]}"; do # access each element of array
      echo "COPY ${schema_name}.${i} FROM  '../cqls/${schema_name}/${schema_name}.${i}.cql' WITH HEADER = true;" >>"./cqls/${export_filename}"
      echo "COPY ${schema_name}.${i} TO  './cqls/${schema_name}/${schema_name}.${i}.cql' WITH HEADER = true;" >>"./cqls/${import_filename}"
    done
    #echo $line
  done <$filename #readtables.cql
}

keyspaces=("akka" "akka_snapshot") #"readtables"
IFS=$','
echo "########## exporting ${keyspaces[*]}"
unset IFS
docker exec -it ${CASSANDRA_CONT_ID} sh -c "mkdir -p cqls"
for keyspace in "${keyspaces[@]}"; do
  export_cassandra_keyspace $keyspace
  docker cp ./cqls/${import_filename} ${CASSANDRA_CONT_ID}:/cqls/${import_filename}                              #Copy import file into docker
  docker exec -it ${CASSANDRA_CONT_ID} sh -c "mkdir -p cqls/${keyspace};cqlsh -f ./cqls/${import_filename}" #execute import file into docker to dump tables
  docker cp ${CASSANDRA_CONT_ID}:"/cqls/${keyspace}" cqls/$keyspace                                  #Copy dumped tables into cqlsh directory
  docker exec -it ${CASSANDRA_CONT_ID} sh -c "cqlsh -e 'DESC KEYSPACE ${keyspace};' > ./cqls/${keyspace}-schema.cql" #execute import file into docker to dump tables
  docker cp ${CASSANDRA_CONT_ID}:"./cqls/${keyspace}-schema.cql" ./cqls/
  rm -f "${keyspace}-tables.cql"                                                                     #remove files if exists
done
docker exec -it ${CASSANDRA_CONT_ID} sh -c "rm -r cqls" #execute import file into docker to dump tables