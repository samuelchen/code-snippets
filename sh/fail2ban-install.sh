#!/bin/sh

# disable firewalld
systemctl stop firewalld
systemctl mask firewalld

# disable selinux (required if change sshd port)
# don't change /etc/sysconfig/selinux, its softlink. "sed -i" will make softlink a real file.
# sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
# setenforce 0


yum install -y epel-release
yum install -y fail2ban iptables-services

IPTABLES_CONF=/etc/sysconfig/iptables
SSH_JAIL_CONF=/etc/fail2ban/jail.d/ssh.conf

sed -i '$d' $IPTABLES_CONF
sed -i '$d' $IPTABLES_CONF
sed -i '$d' $IPTABLES_CONF

cat << EOF >> $IPTABLES_CONF
-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 8080 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF

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
