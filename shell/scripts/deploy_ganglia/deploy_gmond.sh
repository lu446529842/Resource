#!/bin/bash
#
#intall ganglia  client 
#


#=====================================================================
#function	set repos
#=====================================================================
function set_repo(){
 export http_proxy=http://9.123.107.67:3128
 rm -rf /etc/yum.repos.d

 cp -R ${BASE_DIR}/yum.repos.d /etc

 yum clean all
 yum  makecache
}


#=====================================================================
#function	install ganglia client
#=====================================================================
function install_ganglia_client(){
 yum install ganglia ganglia-gmond -y
 cat ${BASE_DIR}/gmond.conf > /etc/ganglia/gmond.conf

 /etc/init.d/iptables stop
 setenforce 0
 service gmond start
}



#=====================================================================
#function	main function
#=====================================================================
function main(){
 export BASE_DIR=$( pwd )
 set_repo
 install_ganglia_client
 unset http_proxy
}

#main
