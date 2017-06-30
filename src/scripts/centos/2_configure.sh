#!/bin/bash

service haproxy restart

# Enable Nginx to start when your system boots
systemctl enable haproxy
