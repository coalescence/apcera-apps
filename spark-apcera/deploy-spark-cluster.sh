#!/bin/bash

set -e

declare -a SLAVE_NAMES

CLUSTER_NAME=$1
NUM_SLAVES=$2
SPARK_PACKAGE=$3
NFS_PROVIDER=$5
NETWORK_NAME="$CLUSTER_NAME-net"
MASTER_NAME="$CLUSTER_NAME-m"
ROUTE_BASE="dev.wgcloud.net"

for (( i=0; i<$2; i++ )); do
	SLAVE_NAMES[i]="$CLUSTER_NAME-s$i"
done

ZEPPELIN_PACKAGE=$4
ZEPPELIN_PACKAGE_NAME=$(echo $ZEPPELIN_PACKAGE | cut -d':' -f3)
ZEPPELIN_NAME="$CLUSTER_NAME-zeppelin"
ZEPPELIN_DIR="/opt/apcera/$ZEPPELIN_PACKAGE_NAME"

# Create Spark slave nodes
function createSlave {
	apc app from package $1 -p $3 -m 2G -dr -e SPARK_MASTER="spark://$MASTER_NAME.apcera.local:7077" -sc '$SPARK_APCERA_HOME/bin/start-slave.sh' --batch
	apc network join $2 -j $1 -da $1
	apc app start $1
}

# Create virtual network for Spark
apc network create $NETWORK_NAME

# Create Spark master node
apc app from package $MASTER_NAME -p $SPARK_PACKAGE -m 2G -dr -sc '$SPARK_APCERA_HOME/bin/start-master.sh' --batch
apc network join $NETWORK_NAME -j $MASTER_NAME -da $MASTER_NAME
apc app update $MASTER_NAME -pa 8080 --batch
apc route add $MASTER_NAME.$ROUTE_BASE -j $MASTER_NAME -p 8080 --http --batch
apc app start $MASTER_NAME

# Get IP of the Spark master
#SPARK_MASTER=`apc network show $NETWORK_NAME | grep -e "Job FQN" -e IPv4 | awk '/spark-m/{getline; print $5}' | cut -d'/' -f1

for SLAVE_NAME in $SLAVE_NAMES
do
	createSlave $SLAVE_NAME $NETWORK_NAME $SPARK_PACKAGE
done

# Create Zeppelin job
apc app from package $ZEPPELIN_NAME -p $ZEPPELIN_PACKAGE -m 1G -e ZEPPELIN_NOTEBOOK_DIR="$ZEPPELIN_DIR/notebook/saved" -sc "$ZEPPELIN_DIR/bin/zeppelin-daemon.sh start" --batch
apc app update $ZEPPELIN_NAME -pa 8080 --batch
apc route add $ZEPPELIN_NAME.$ROUTE_BASE -j $ZEPPELIN_NAME -p 8080 --http --batch
apc service create $(awk '{print tolower($ZEPPELIN_NAME)}')-fs -t nfs --provider $NFS_PROVIDER -- --mountpath "$ZEPPELIN_DIR/notebook/saved" --batch
apc network join $NETWORK_NAME -j $ZEPPELIN_NAME -da $ZEPPELIN_NAME
apc app start $ZEPPELIN_NAME
