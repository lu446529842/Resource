#!/bin/bash

#==============================================================
#function	clean openstack dashboard
#==============================================================
function clean_dashboard(){
 yum remove -y mod_wsgi openstack-dashboard
 rm -rf /etc/openstack-dashboard

 /etc/init.d/httpd restart
 /etc/init.d/memcached restart
}

clean_dashboard
