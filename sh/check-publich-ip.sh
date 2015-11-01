#!/bin/bash

#monitor IP change

ip_old=ip_old.txt   
ip_now=ip_now.txt
mail_sender=xxx@xxx.com    #发件人
mail_user=xxx@xxx.com      #收件人
mail_subject=IP_MONITOR    #邮件标题

#init ip.old
while [ ! -f $ip_old ]; do
    /usr/bin/curl ifconfig.me > $ip_old
done
#get ip now
/usr/bin/curl ifconfig.me > $ip_now
#compare
/usr/bin/diff $ip_now $ip_old
#if different change ip_old and send mail
if [ $? != 0 ];then
    cat $ip_now >$ip_old
    echo "IP has changed , the new IP is $(cat $ip_now ) !!!" |mail -s "$mail_subject" -S from=$mail_sender "$mail_user"
fi
fi
done
