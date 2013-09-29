#########################################################################
# File Name: install_lvs_server.sh
# Author: ldq
# mail: 446529842@qq.com
# Created Time: 2013年09月11日 星期三 15时16分24秒
#########################################################################
#!/bin/bash


#########################################################################
#function set forward params
#########################################################################
function set_forward(){
 echo 1 > /proc/sys/net/ipv4/ip_forward
 cat /etc/sysctl.conf | grep "net.ipv4.ip_forward" > /etc/sysctl.conf
 echo "net.ipv4.ip_forward = 1"  >> /etc/sysctl.conf

 yum install -y ipvsadm
}

#########################################################################
#function set inc 
#########################################################################
function set_up_inc(){
 realIP = ${RIP}
 virtualIP = ${VIP}
 ifconfig eth0 ${realIP}
 ifconfig eth0:0 ${virtualIP}  broadcast ${virtualIP} netmask 255.255.255.255 up

}

#########################################################################
#function set  forward server
#########################################################################
function set_forward_server(){
 ipvsadm -C
 virtualIP = ${VIP}
 ipvsadm -A -t ${virtualIP}  -s wrr
}

#########################################################################
#function main 
#########################################################################
function main(){
 set_forward "${@}"
 set_up_inc "${@}"
 set_forward_server "${@}"
}
