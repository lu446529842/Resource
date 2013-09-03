#!/bin/bash
#install ganglia server
#

#=======================================================
#function	install ganglia server
#=======================================================
function install_ganglia(){
 yum install -y yum install rrdtool ganglia-gmetad ganglia-gmond ganglia-web httpd php
 sed "s#<MY_CLUSTER>#${CLUSTER_NAME}#g" ${BASE_DIR}/gmetad.conf > /etc/ganglia/gmetad.conf
 sed "s#<MY_CLUSTER>#${CLUSTER_NAME}#g" ${BASE_DIR}/gmond.conf > /etc/ganglia/gmond.conf
 service gmond start
 service gmetad start
 service httpd start
}



#=======================================================
#function	main
#=======================================================
function main(){
 export CLUSTER_NAME="my_cluster"
 export BASE_DIR=$( pwd )
 install_ganglia
}
