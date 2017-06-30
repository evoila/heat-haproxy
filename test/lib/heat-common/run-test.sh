#!/bin/bash

DISTRIBUTION=$1
KEY=$2
IMAGE=$3
FLAVOR=$4
PUBLIC_NETWORK=$5

for TEST in prepare-volume; do 
#for TEST in copy-file hosts-file java prepare-volume; do 
 openstack stack create -t test/$TEST.yaml\
  -e test/lib/heat-iaas/resources.yaml\
  -e resources-$DISTRIBUTION.yaml\
  --parameter key=$KEY\
  --parameter image=$IMAGE\
  --parameter flavor=$FLAVOR\
  --parameter public_network=$PUBLIC_NETWORK\
  --wait\
  test-$TEST
done
