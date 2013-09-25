#!/bin/bash
#deploy cobbler server for os installation automation
#

#==========================================================
#function	install package
#==========================================================
function install_package(){
 #install necessary package
 yum install -y dhcp  tftp  rsync  xinten  httpd
 
 #install cobbler
 yum install cobbler
 
 /etc/init.d/cobblerd restart
 echo "ServerName 127.0.0.1" >> /etc/httpd/conf/httpd.conf
 /etc/init.d/httpd restart
 cobbler check
}



#==========================================================
#function	set up all kinds of configure
#==========================================================
function set_up_configure(){
 #set up /etc/cobbler/settings
 sed -e "s#<SERVER>#${LOACL_IP}#g" -e "s#<NEXT_SERVER>#${LOACL_IP}#g" -e "s#<PASSWORD>#${PASSWORD}#g" -e "s#<MANAGE_DHCP>#${MANAGE_DHCP}#g" ${BASE_DIR}/settings > /etc/cobbler/settings
 
 #set up /etc/selinux/config
 sed "s#<SELINUIX>#${SELINUIX}#g" ${BSE_DIR}/config > /etc/selinux/config
 setenforce 0

 #cobbler get-loaders
 cobbler get-loaders

 #set up /etc/xinetd.d/rsync 
 cat /etc/rsync > /etc/xinetd.d/rsync

 #install pykickstart cman
 yum install -y pykickstart cman
 cobbler check

 #set up dhcp template
 sed -e "s#<SUBNET>#${SUBNET}#g" -e "s#<NETMASK>#${NETMASK}#g" -e "s#<ROUTE>#${ROUTE}#g" -e "s#<DOMAIN>#${DOMAIN}#g" -e "s#<RANGE_START>#${RANGE_START}#g" -e "s#<RANGE_END>#${RANGE_END}#g" ${BASE_DIR}/dhcp.template > /etc/cobbler/dhcp.template

}


#==========================================================
#function	mount and import iso
#==========================================================
function mount_import_iso(){
 mkdir ${BASE_DIR}/ISO
 mount -o loop -iso9660 ${ISO_DIR} ${BASE_DIR}/ISO
 cobbler import --path=${BASE_DIR}/ISO --name=${ISO_NAME} --arch=${ARCH}
 cobbler sync
 
}


#==========================================================
#function start and set up all service
#==========================================================
function start_set_up_service(){
 chkconfig --level 35 httpd on
 chkconfig --level 35 xinetd on
 chkconfig --level 35 cobbler on 

 /etc/init.d/httpd restart
 /etc/init.d/xinetd restart
 /etc/init.d/cobbler restart 
}

#==========================================================
#function	main
#==========================================================
function main(){
 export BASE_DIR=$( pwd )
 export LOACL_IP=$( ifconfig eth0  |grep "inet addr" |grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}' )
 export PASSWORD=$( openssl passwd -1 -salt 'time4fun' 'time4fun' )
 export MANAGE_DHCP=1 
 export SELINUIX="disabled"
 #set up network
 export SUBNET=""
 export NETMASK=""
 export ROUTE=""
 export DOMAIN=""
 export RANGE_START=""
 export RANGE_END=""
 #set up iso image
 export ISO_DIR=""
 export ISO_NAME=""
 export ARCH=""

 install_package
 set_up_configure
 mount_import_iso
 start_set_up_service
}

