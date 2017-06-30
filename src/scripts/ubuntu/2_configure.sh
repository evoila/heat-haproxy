#!/bin/bash

GLOBAL_CONFIG=${GLOBAL_CONFIG:-}
DEFAULT_CONFIG=${DEFAULT_CONFIG:-}
LISTENER_CONFIGS=${LISTENER_CONFIGS:-[]}

if [ -z $GLOBAL_CONFIG ]; then
  GLOBAL_CONFIG=$(cat <<EOF
global
 log /dev/log local0
 log /dev/log local1 notice
 chroot /var/lib/haproxy
 stats socket /run/haproxy/admin.sock mode 660 level admin
 stats timeout 30s
 user haproxy
 group haproxy
 daemon
 ca-base /etc/ssl/certs
 crt-base /etc/ssl/private
 ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
 ssl-default-bind-options no-sslv3
EOF)
fi

if [ -z $DEFAULT_CONFIG ]; then
  DEFAULT_CONFIG=$(cat <<EOF
defaults
 log global
 mode http
 option httplog
 option dontlognull
 timeout connect 5000
 timeout client 50000
 timeout server 50000
 errorfile 400 /etc/haproxy/errors/400.http
 errorfile 403 /etc/haproxy/errors/403.http
 errorfile 408 /etc/haproxy/errors/408.http
 errorfile 500 /etc/haproxy/errors/500.http
 errorfile 502 /etc/haproxy/errors/502.http
 errorfile 503 /etc/haproxy/errors/503.http
 errorfile 504 /etc/haproxy/errors/504.http
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
