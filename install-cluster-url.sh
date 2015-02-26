#!/bin/bash

: ${AMBARI_HOST:=$AMBARISERVER_PORT_8080_TCP_ADDR}
: ${BLUEPRINT:=single-node-hdfs-yarn}
: ${BLUEPRINT_NAME:=single-node-hdfs-yarn}
: ${BLUEPRINT_URL:=single-node-hdfs-yarn}

echo AMBARI_HOST=${AMBARI_HOST:? ambari server address is mandatory, fallback is a linked containers exposed 8080}

java -jar ambari-shell.jar --ambari.host=$AMBARI_HOST << EOF
blueprint add --url $BLUEPRINT_URL
cluster build --blueprint $BLUEPRINT_NAME
cluster autoAssign
cluster create --exitOnFinish true
EOF
