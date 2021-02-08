#!/usr/bin/env bash

# To create MariaDB cluster with Galera (Master - Master, sync)

IPS=(192.168.56.10 192.168.56.11 192.168.56.12)
IP_CNT=${#IPS[*]}
for ip in ${IPS[*]}; do tmp=${tmp},${ip}; done
IP_COMMA_STR=${tmp:1}

ID=$1

i=0
if [ "${ID}" = "" ] || [ ${ID} -lt 0 ] || [ ${ID} -ge ${IP_CNT} ]; then
	echo "You must specify an ID:"
	printf "ID \t\tIP\n";
	echo "-----------------------";
	for ip in ${IPS[*]}
	do
		printf "${i}:\t\t${ip}\n";
		((i++));
	done
	exit 1
fi

IP=${IPS[ID]}

echo "Configure MariaDB-Galera for $IP"
read -p "Press any key to continue..." tmp


cd  /etc/my.cnf.d

cat <<END >galera.cnf
[galera]
# Mandatory settings
wsrep_on=ON
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_name=kdl_cluster
wsrep_cluster_address="gcomm://${IP_COMMA_STR}"
wsrep_node_name=$IP
wsrep_node_address=$IP
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2

# Allow server to accept connections on all interfaces.
#
#bind-address=0.0.0.0
#
# Optional setting
#wsrep_slave_threads=1
#innodb_flush_log_at_trx_commit=0

END

#exit 0

#semanage permissive -a mysqld_t
systemctl disable firewalld.service
systemctl stop firewalld.service

setenforce 0
sed -i 's/^SELINUX=.*$/SELINUX=disabled/'  /etc/selinux/config

# yum install -y galera rsync


cat <<END
# configure node 0 (which already has data)
mysql_upgrade
systemctl stop mariadb.service
galera_new_cluster
systemctl start mariadb.service
END

echo ""

cat <<END
# configure node 1..N (which is new to cluster without data)
systemctl restart mariadb.service
END


