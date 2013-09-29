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

cd /etc/swift
swift-ring-builder account.builder create 18 3 1
swift-ring-builder container.builder create 18 3 1
swift-ring-builder object.builder create 18 3 1  


