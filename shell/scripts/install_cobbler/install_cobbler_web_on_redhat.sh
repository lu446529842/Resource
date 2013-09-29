#!/bin/bash
#install web portal for cobbler
#
#================================================
#function	install and set up cobbler web
#================================================
function install_and_configure(){
 yum install -y cobbler-web
 #reset default user cobbler's password
 htdigest /etc/cobbler/users.digest "Cobbler" cobbler
 
 cat ${BASE_DIR}/modules.conf > /etc/cobbler/modules.conf
 service cobblerd restart
 service httpd restart
}


#===========================================
#function	main
#===========================================
function main(){
 export BASE_DIR=$( pwd )
 install_and_configure
}
