#!/bin/bash

#======================================================
#function 	install necessary package
#======================================================
function install_package(){
 #install package
 yum install -y  bind bind-chroot bind-utils caching-nameserver

 #set up simple config
 cd /etc
 # make backup
 mv named.conf named.conf.bak
 grep -v '//' named.rfc1912.zones > named.conf
 chown root:named named.conf
 chmod 640 named.conf
}


#======================================================
#function set root.zone
#======================================================
function set_root_zone(){
 #donwload and restart service
 cd /var/named
 wget ftp://rs.internic.net/domain/root.zone
 /etc/init.d/named restart
}


#======================================================
#function	main
#======================================================
function main(){
 install_package
 set_root_zone
 
 echo "#==========================================="
 echo "#=======  test local DNS service  =========="
 echo "#==========================================="
 echo "======  dig www.baidu.com @127.0.0.1  ======"
 echo ""

 dig www.baidu.com @127.0.0.1
}
