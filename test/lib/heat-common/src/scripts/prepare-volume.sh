#!/bin/bash

MOUNTPOINT=${MOUNTPOINT:-/mnt}
FILESYSTEM=${FILESYSTEM:-ext4}
FILESYSTEM_LABEL=${FILESYSTEM_LABEL:-volume}

# Find volume device file
ROOT_DISK=$(cat /proc/mounts | grep -E "/dev/[vhs]d[a-z][0-9] /" | awk '{ print $1 }' | sed 's/[0-9]$//')
VOLUME_DISK=$(fdisk -l | grep -E "Disk /dev/[hsv]d[a-z]" | grep -v "$ROOT_DISK" | head -n1 | awk '{ print $2 }' | sed 's/://')

# Prepare file system 
mkfs.$FILESYSTEM -L $FILESYSTEM_LABEL $VOLUME_DISK
FS_UUID=$(blkid | grep "$VOLUME_DISK" | awk '{ print $3 }' | cut -d "=" -f 2 | sed 's/"//g')

if [ ! -d $MOUNTPOINT ]; then
  mkdir -p $MOUNTPOINT
fi

mount $VOLUME_DISK $MOUNTPOINT

# Make mount persistent
cat <<EOF >> /etc/fstab
UUID=${FS_UUID} $MOUNTPOINT ext4 defaults,errors=remount-ro 0 1
EOF
