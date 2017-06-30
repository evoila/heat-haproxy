#!/bin/bash

apt-get install -y python-software-properties debconf-utils

add-apt-repository -y ppa:webupd8team/java
apt-get update

PACKAGES="oracle-java8-installer oracle-java8-set-default"
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
apt-get install -y $PACKAGES
