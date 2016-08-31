#!/bin/bash

function createSlave {
	apc app from package $1 -p $4 -m 1G -dr -e SPARK_MASTER=spark://$2:7077 --start-cmd '$SPARK_APCERA_HOME/bin/start-slave.sh' --batch
	apc network join $3 -j $1
	apc app start $1
}

export SPARK_PACKAGE="/wg/pkg/packages::spark-apcera-2.0.0"
export NETWORK_NAME=sparknet
export MASTER_NAME=spark-m
export SLAVE_NAMES="spark-s1 spark-s2 spark-s3"
export ROUTE_BASE=dev.wgcloud.net

apc network create $NETWORK_NAME

apc app from package $MASTER_NAME -p $SPARK_PACKAGE -m 1G -dr --start-cmd '$SPARK_APCERA_HOME/bin/start-master.sh' --batch
apc network join $NETWORK_NAME -j $MASTER_NAME
apc app update $MASTER_NAME -pa 8080 --batch
apc route add $MASTER_NAME.$ROUTE_BASE -j $MASTER_NAME -p 8080 --http --batch
apc app start $MASTER_NAME

export SPARK_MASTER=`apc network show $NETWORK_NAME | grep -e "Job FQN" -e IPv4 | sed -ne '/^.*'$MASTER_NAME'.*$/{s///; :a' -e 'n;p;ba' -e '}' | grep "IPv4" -m 1 | sed -E "s/[[:space:]]+/ /g" | cut -d' ' -f 5 | sed -E "s:/.*$::"`

for SLAVE_NAME in $SLAVE_NAMES
do
	createSlave $SLAVE_NAME $SPARK_MASTER $NETWORK_NAME $SPARK_PACKAGE
done
