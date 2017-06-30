#!/bin/bash

# Install nginx
apt-get update
apt-get install -y haproxy

# Stop service
service haproxy stop
