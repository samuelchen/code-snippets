#!/bin/sh

# to mount VMWare share folders
# author: Samuel Chen <samuel.net@gmail.com>

# mount point
SHARE=/mnt/VMShares

# check if folder exists
if [ -d $SHARE ]; then
  echo "VM share folder is existed. ($SHARE)"
else
  mkdir $SHARE
fi

# chef if folder is empty
files=`ls $SHARE`
if [ -z "$files" ]; then
  # mount all
  mount -t vmhgfs .host:/ $SHARE
else
  echo "$SHARE was mounted!"
fi

echo "$SHARE"
ls $SHARE
