#!/usr/bin/env sh

IP=$1
sudo fail2ban-client set ssh-iptables unbanip ${IP}
