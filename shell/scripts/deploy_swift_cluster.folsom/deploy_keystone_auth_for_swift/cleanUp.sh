#!/bin/bash

yum remove -y  openstack-utils openstack-keystone python-keystoneclient   MySQL-python 

for item in $( rpm -aq |grep mysql | grep -v "mysql-libs" )
  do
   rpm -e ${item}
  done


rm -rf /etc/keystone
rm -rf /var/lib/mysql
