#!/bin/bash

FILE=${FILE}
CREDENTIALS=${CREDENTIALS}

# Create and/or clear file
touch $FILE
truncate -s 0 $FILE

# Write passord file
CRED_LIST=$( echo $CREDENTIALS | sed 's/\[//g' | sed 's/\]//g' | sed 's/"//g' | sed 's/,//g' )
for CRED in $CRED_LIST; do
  USER=$( echo $CRED | cut -d ':' -f 1)
  PASS=$( echo $CRED | cut -d ':' -f 2)
  htpasswd -b $FILE "$USER" "$PASS"
done
