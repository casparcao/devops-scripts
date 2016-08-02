#!/bin/sh

##
#将连接数超过100的ip加入防火墙进行拦截
##
export PATH=$PATH:/sbin
BAD_LIST="./badips.tmp"
GOOD_LIST="/data/goodips.list"
NO_OF_CONNECTIONS=100

function ipexists()
{
	IPTABLES_FILE="/etc/sysconfig/iptables"
	for line in `cat $IPTABLES_FILE`
	do
		echo "$line" | grep -q "$1"
		if [ $? -eq 0 ]; then
			return 1
		fi	
	done
	return 0
}

function isgoodip()
{
	for line in `cat $GOOD_LIST`
	do
		if [ "$line" == "$1" ]; then
			return 1
		fi
	done
	return 0
}


netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr > $BAD_LIST
while read line
do
	count=`echo $line | awk '{print $1}'`
	ip=`echo $line | awk '{print $2}'`
	ipexists $ip
	exists=$?	
	isgoodip $ip
	goodip=$?
	if [ $exists -eq 0 -a $goodip -eq 0 -a "$count" -gt "$NO_OF_CONNECTIONS" ]; then
		iptables -I INPUT -s $ip -j DROP
		echo $ip
	fi
done < $BAD_LIST
service iptables save

