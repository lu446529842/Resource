#bin/bash
#
#deploy ganglia gmetad 
#
#

#===========================================================================
#function install Dependency
#===========================================================================
function install_dependency(){
 yum install -y mailcap httpd-tools  apr-util-ldap apr-util  httpd
 yum install -y php-common php-cli php-gd php
}


