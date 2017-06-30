#!/bin/bash

GLOBAL_CONFIG=${GLOBAL_CONFIG:-}
DEFAULT_CONFIG=${DEFAULT_CONFIG:-}
LISTENER_CONFIGS=${LISTENER_CONFIGS:-[]}

if [ -z $GLOBAL_CONFIG ]; then
  GLOBAL_CONFIG=$(cat <<EOF
global
 log         127.0.0.1 local2
 chroot      /var/lib/haproxy
 pidfile     /var/run/haproxy.pid
 maxconn     4000
 user        haproxy
 group       haproxy
 daemon
 stats socket /var/lib/haproxy/stats
EOF)
fi

if [ -z $DEFAULT_CONFIG ]; then
  DEFAULT_CONFIG=$(cat <<EOF
defaults
 mode                    http
 log                     global
 option                  httplog
 option                  dontlognull
 option http-server-close
 option forwardfor       except 127.0.0.0/8
 option                  redispatch
 retries                 3
 timeout http-request    10s
 timeout queue           1m
 timeout connect         10s
 timeout client          1m
 timeout server          1m
 timeout http-keep-alive 10s
 timeout check           10s
 maxconn                 3000
EOF)
fi

echo -e "$GLOBAL_CONFIG\n" > /etc/haproxy/haproxy.cfg
echo -e "$DEFAULT_CONFIG\n" >> /etc/haproxy/haproxy.cfg

LENGTH=$(echo ${LISTENER_CONFIGS} | /usr/bin/jq 'length')
LAST_INDEX=$((LENGTH-1))
for I in `seq 0 $LAST_INDEX`; do
  CONFIG=$(echo $LISTENER_CONFIGS | /usr/bin/jq -r ".[$I]" )
  echo -e "$CONFIG\n" >> /etc/haproxy/haproxy.cfg
done

service haproxy restart
