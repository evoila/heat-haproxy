#!/usr/bin/python
import os

hostnames = eval(os.environ['hostnames'])
addresses = eval(os.environ['addresses'])

def write_hosts(hostnames, addresses, file):
  f.write('DO NOT EDIT! THIS FILE IS MANAGED VIA HEAT\n\n')
  f.write('127.0.0.1 localhost\n\n')

  for idx, hostname in enumerate(hostnames):
    f.write(addresses[idx] + ' ' + hostname + '\n')

  f.write('\n')
  f.write('# The following lines are desirable for IPv6 capable hosts\n')
  f.write('::1 ip6-localhost ip6-loopback\n')
  f.write('fe00::0 ip6-localnet\n')
  f.write('ff00::0 ip6-mcastprefix\n')
  f.write('ff02::1 ip6-allnodes\n')
  f.write('ff02::2 ip6-allrouters\n')
  f.write('ff02::3 ip6-allhosts\n')

with open('/etc/hosts', 'w') as f:
  write_hosts(hostnames, addresses, f)
