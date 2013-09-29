#########################################################################
# File Name: set_up_client.sh
# Author: ldq
# mail: 446529842@qq.com
# Created Time: 2013年09月11日 星期三 14时56分33秒
#########################################################################
#!/bin/bash


#########################################################################
#function	set up NIC
#########################################################################
function set_up_INC(){
 realIP = ${RIP}
 VIP = ${VIP}

 ifconfig eth0 ${realIP}

 echo 1 >/proc/sys/net/ipv4/conf/lo/arp_ignore
 echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
 echo 2 >/proc/sys/net/ipv4/conf/all/arp_announce
 echo 2 >/proc/sys/net/ipv4/conf/lo/arp_announce
 
 ifconfig lo:0 ${VIP} broadcast ${VIP} netmask 255.255.255.255 up

}


#########################################################################
#function	main
#########################################################################
function main(){
 set_up_INC "${@}"
}
