#!/bin/sh

# disable firewalld
systemctl stop firewalld
systemctl mask firewalld

# disable selinux (required if change sshd port)
# don't change /etc/sysconfig/selinux, its softlink. "sed -i" will make softlink a real file.
# sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
# setenforce 0


dnf install -y epel-release
dnf install -y fail2ban iptables-services

IPTABLES_CONF=/etc/sysconfig/iptables
SSH_JAIL_CONF=/etc/fail2ban/jail.d/ssh.conf

cp $IPTABLES_CONF ./iptables.bak

#sed -i '$d' $IPTABLES_CONF
#sed -i '$d' $IPTABLES_CONF
#sed -i '$d' $IPTABLES_CONF

iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 2222 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 4433 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 315 -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
iptables-save > $IPTABLES_CONF

cat << EOF > $SSH_JAIL_CONF
[ssh-iptables]

enabled  = true
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           sendmail-whois[name=SSH, dest=root, sender=fail2ban@example.com, sendername="Fail2Ban"]
logpath  = /var/log/secure
maxretry = 5
bantime = 86400
EOF

systemctl restart iptables
systemctl enable iptables

systemctl restart fail2ban
systemctl enable fail2ban
