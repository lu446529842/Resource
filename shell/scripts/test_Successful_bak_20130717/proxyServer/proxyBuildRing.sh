#!/bin/bash
#
#create ring after install proxy server for a cluster
#
#all right reserved by ludaquan (ludaquan@cn.ibm.com)
#
#

#===================================================================================
#usage		run it in a proxy server
#	./xx.sh
#===================================================================================

echo "#==================================================================="
echo "# create with default partition_size partition_num min_moving_partition_time"
echo "#==================================================================="


cd /etc/swift
swift-ring-builder account.builder create 18 3 1
swift-ring-builder container.builder create 18 3 1
swift-ring-builder object.builder create 18 3 1  


