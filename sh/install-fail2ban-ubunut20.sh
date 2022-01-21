#!/bin/sh

# disable firewalld
systemctl stop firewalld
systemctl mask firewalld

ufw disable
apt remove -y ufw
apt purge -y ufw

# disable selinux (required if change sshd port)
# don't change /etc/sysconfig/selinux, its softlink. "sed -i" will make softlink a real file.
# sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
# setenforce 0


apt install -y fail2ban iptables

IPTABLES_CONF=/etc/iptables
IPTABLES_INIT_FILE=/etc/network/if-pre-up.d/iptables
SSH_JAIL_CONF=/etc/fail2ban/jail.d/ssh.conf

cp $IPTABLES_CONF ./iptables.bak 1>/dev/null 2>&1

cat << EOF > $IPTABLES_CONF
# sample configuration for iptables service
# you can edit this manually or use system-config-firewall
# please do not ask us to add additional ports/services to this default configuration
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 8080 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 2222 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 4433 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 31522 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 6443 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
EOF

#iptables-save > $IPTABLES_CONF
iptables-restore < $IPTABLES_CONF

cat << EOF > $IPTABLES_INIT_FILE
#!/bin/bash
iptables-restore < $IPTABLES_CONF
EOF

chmod +x $IPTABLES_INIT_FILE

cat << EOF > $SSH_JAIL_CONF
[ssh-iptables]

enabled  = true
filter   = sshd
action   = iptables[name=SSH, port=ssh, protocol=tcp]
           sendmail-whois[name=SSH, dest=root, sender=fail2ban@example.com, sendername="Fail2Ban"]
logpath  = /var/log/auth.log
maxretry = 5
bantime = 86400
EOF

#systemctl restart iptables
#systemctl enable iptables

systemctl restart fail2ban
systemctl enable fail2ban
