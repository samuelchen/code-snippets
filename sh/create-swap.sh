#/bin/sh

# https://www.vultr.com/docs/setup-swap-file-on-linux

SIZE=1024
FILE=/swapfile

dd if=/dev/zero of=${FILE} count=${SIZE} bs=1M

chmod 600 ${FILE}

mkswap ${FILE}

swapon ${FILE}

echo "${FILE}	none	swap	sw	0	0" >> /etc/fstab
