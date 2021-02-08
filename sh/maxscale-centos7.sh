#!/usr/bin/env bash

# to create MariaDB HA proxy with MaxScale

URL=https://dlm.mariadb.com/1496729/MaxScale/2.5.7/packages/rhel/7/maxscale-2.5.7-1.rhel.7.x86_64.rpm
FNAME=maxscale-2.5.7-1.rhel.7.x86_64.rpm

IP=192.168.56.19
DB_IPS=(192.168.56.10 192.168.56.11 192.168.56.12)
DB_IP_CNT=${#DB_IPS[*]}
DB_SVC_PREFIX=db

USER=maxscale
PASSWD=maxscale

MONITOR_USER=maxscale
MONITOR_PASSWD=maxscale
MONITOR_INTERVAL=300ms

DB_USER=kuaidaili
DB_PASSWD=kuaidaili


echo "Configure MariaDB-MaxScale on ${IP} for ${DB_IPS[*]}"
read -p "Press any key to continue..." tmp

systemctl disable firewalld.service
systemctl stop firewalld.service

setenforce 0
sed -i 's/^SELINUX=.*$/SELINUX=disabled/'  /etc/selinux/config

if [ ! -f ${FNAME} ]; then
	yum install -y wget
	wget ${URL}
fi

if [ ! -f ${FNAME} ]; then
        echo "Fail to download ${FNAME}."
        echo "Try again or download it by yourself at ${URL}"
		exit 2
fi
yum install -y ${FNAME}


cat <<END >/etc/maxscale.cnf
[maxscale]
threads=auto
END

i=0
DB_COMMA_STR=
for ip in ${DB_IPS[*]}
do
DB_COMMA_STR=${DB_COMMA_STR},${DB_SVC_PREFIX}${i}
cat <<END >>/etc/maxscale.cnf

[${DB_SVC_PREFIX}${i}]
type=server
address=${DB_IPS[i]}
port=3306
protocol=MariaDBBackend
END
((i++))
done
DB_COMMA_STR=${DB_COMMA_STR:1}

cat <<END >>/etc/maxscale.cnf

# [Replication-Monitor]
# type=monitor
# module=mariadbmon
# servers=${DB_COMMA_STR}
# user=${MONITOR_USER}
# password=${MONITOR_PASSWD}
# monitor_interval=${MONITOR_INTERVAL}
# auto_failover=true
# auto_rejoin=true

[Galera-Monitor]
type=monitor
module=galeramon
servers=${DB_COMMA_STR}
user=${MONITOR_USER}
password=${MONITOR_PASSWD}
monitor_interval=${MONITOR_INTERVAL}

[Splitter-Service]
type=service
router=readwritesplit
servers=${DB_COMMA_STR}
user=${USER}
password=${PASSWD}

[Splitter-Listener]
type=listener
service=Splitter-Service
protocol=MariaDBClient
port=3306

END


cat <<END

-- to create MaxScale user
CREATE USER '${USER}'@'%' IDENTIFIED BY '${PASSWD}';
GRANT SHOW DATABASES ON *.* TO '${USER}'@'%';
GRANT SELECT ON mysql.* TO '${USER}'@'%';

-- to create monitor user and grant privileges
CREATE USER '${MONITOR_USER}'@'%' IDENTIFIED BY '${MONITOR_PASSWD}';
GRANT REPLICATION CLIENT on *.* to '${MONITOR_USER}'@'%';

-- if automatic failover by Monitor. use following privilege
GRANT SUPER, RELOAD on *.* to '${MONITOR_USER}'@'%';


-- to create DB user on MaxScale host
CREATE USER '${DB_USER}'@'${IP}' IDENTIFIED BY '${DB_PASSWD}';

-- show DB user privileges on DB
SHOW GRANTS FOR '${DB_USER}'@'${DB_IPS[0]}'

-- grant privileges to new DB user on MaxScale host
-- use the GRANT query listed above to '${DB_USER}'@'${IP}'


# Restart MaxScale service after you created USER.

END


