#!/bin/bash

LISTENER_NAME=${LISTENER_NAME}
LISTENER_OPTIONS=${LISTENER_OPTIONS}
BIND_ADDR=${BIND_ADDR}
BIND_PORT=${BIND_PORT}
OPTIONS=${OPTIONS:-'[]'}
SERVER_NAMES=${SERVER_NAMES:-'[]'}
SERVER_ADDRS=${SERVER_ADDRS:-'[]'}
SERVER_PORT=${SERVER_PORT:-}
SERVER_OPTS=${SERVER_OPTS:-}

TEMP_FILE="/tmp/haproxy-conf-$NAME"

cat <<EOF > $TEMP_FILE
listen $LISTENER_NAME $LISTENER_OPTIONS
 bind $BIND_ADDR:$BIND_PORT
EOF

LENGTH=$(echo ${OPTIONS} | /usr/bin/jq 'length')
LAST_INDEX=$((LENGTH-1))
for I in `seq 0 $LAST_INDEX`; do
  LINE=$(echo $OPTIONS | /usr/bin/jq -r ".[$I]" )
  echo " $LINE" >> $TEMP_FILE
done

LENGTH=$(echo ${SERVER_NAMES} | /usr/bin/jq 'length')
LAST_INDEX=$((LENGTH-1))
for I in `seq 0 $LAST_INDEX`; do
  NAME=$(echo $SERVER_NAMES | /usr/bin/jq -r ".[$I]" )
  if [ "$NAME" == "null" ]; then NAME=""; fi

  ADDR=$(echo $SERVER_ADDRS | /usr/bin/jq -r ".[$I]" )
  if [ "$ADDR" == "null" ]; then ADDR=""; fi

  echo " server $NAME $ADDR:$SERVER_PORT $SERVER_OPTS" >> $TEMP_FILE
done

cp $TEMP_FILE ${heat_outputs_path}.config
