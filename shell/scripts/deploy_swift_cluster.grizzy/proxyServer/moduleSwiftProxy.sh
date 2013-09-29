#!/bin/bash
#
#install openstack folsom swift proxy node 
#
#all right reserved by lu da quan (ludaquan@cn.ibm.com)
#
#

#====================================================================
#usage
# ./moduleSwiftProxy.sh param_1
# param_1 is a keystone auth server IP
#====================================================================



#================================================================================================
#function:      check error if cmd fail to execution
#================================================================================================
function check_error(){

  status=$1
  cmd=$2
  func=$3

  if [ ${status} -ne 0 ]
  then

          time_info=$( date +'%Y-%m-%d %H:%M:%S' )
          error_info="command ${cmd} fail ro execution  in function  ${func} ,exit status :${status} "
          echo ""
          echo "#===============ERROR LOG==============================================================="
          echo "#=   error_time: ${time_info}"
          echo "#=   error_info: ${error_info}"
          echo "#======================================================================================="
          echo ""
  else
        echo "command ${cmd}   in function  ${func}  execution Successfully!!"
        echo ""
  fi


}




#====================================================================
#function       set local ENV
#====================================================================i

function set_local_env(){
echo "set local env"
sleep 1

STORAGE_LOCAL_NET_IP=$( ifconfig |grep "inet addr" |grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}' )
export STORAGE_LOCAL_NET_IP

echo "finish !"
sleep 1

}


#====================================================================
#function       configure and update local Repos
#====================================================================

function configure_update_Repos(){
echo "configure a local yum Repos"
sleep 1

touch /etc/yum.repos.d/redhat.repo
sed 's#<HTTP_SOURCE>#source#g' ${BASE_DIR}/repo/redhat.repo > /etc/yum.repos.d/redhat.repo

yum update

sleep 1

}

#=====================================================================================
#function	install and configure openstack-swift-proxy
#=====================================================================================

function install_swift_proxyServer(){
echo "install and configure openstack-swift-proxy"
sleep 1

yum install openstack-swift-proxy -y
check_error "$?" "yum install openstack-swift-proxy -y" "install_swift_proxyServer"

sleep 1

touch /etc/swift/proxy-server.conf


sed -e "s#<AUTH_HOST>#${auth_host}#g"   -e "s#<LOCALHOST>#${STORAGE_LOCAL_NET_IP}#g" -e "s#<MEMCAHE_SERVERS>#${STORAGE_LOCAL_NET_IP}:11211#g"  ${BASE_DIR}/etc.conf/proxy-server.conf > /etc/swift/proxy-server.conf


chown -R swift:swift /etc/swift

}


#=====================================================================================
#function install swift
#=====================================================================================

function install_swift(){
echo "install openstack-swift"
sleep 1
yum install openstack-swift -y
check_error "$?" "yum install openstack-swift -y"  "install_swift"
touch /etc/swift/swift.conf
cat $BASE_DIR/etc.conf/swift.conf > /etc/swift/swift.conf
sleep 1
}
#=====================================================================================
#function	install and configure memcached 
#=====================================================================================

function install_memcached(){
echo "install and configure memcached "
sleep 1

yum install  memcached  -y
check_error "$?" "yum install  memcached  -y" "install_memcached"
touch /etc/memcached.conf

sed "s#<IP_ADDRESS>#${STORAGE_LOCAL_NET_IP}#g" ${BASE_DIR}/etc.conf/memcached.conf > /etc/memcached.conf


echo "finished!"
sleep 1
}



#=====================================================================================
#function	install python-swiftclient
#=====================================================================================

function install_python_swiftclient(){
echo "install python-swiftclient"
sleep 1

yum install python-swiftclient -y
check_error "$?" "yum install python-swiftclient -y"  "install_python_swiftclient"

sleep 1
}



#=====================================================================================
#function	install	python-keystoneclient
#=====================================================================================

function install_python_keystoneclient(){
echo "install python-keystoneclient"
sleep 1

yum install python-keystoneclient -y
check_error "$?" "yum install python-keystoneclient -y" "install_python_keystoneclient"

sleep 1
}


#=====================================================================================
#function configure proxy log
#=====================================================================================

function config_proxy_log(){
echo "configure log"
sleep 2

touch /etc/rsyslog.d/rsyslog-swift.conf
cat ${BASE_DIR}/etc.conf/rsyslog-swift.conf > /etc/rsyslog.d/rsyslog-swift.conf

mkdir -p /var/log/swif
service rsyslog restart
echo "finished!"
sleep 1

}


#===================================================================================
#function       builder ring file
#===================================================================================
function build_ring(){
 echo "#==========================================================================="
 echo "# create with default partition_size partition_num min_moving_partition_time"
 echo "#==========================================================================="


 cd /etc/swift
 swift-ring-builder account.builder create 18 3 1
 check_error "$?" "swift-ring-builder account.builder create 18 3 1" "main"

 swift-ring-builder container.builder create 18 3 1
 check_error "$?" "swift-ring-builder container.builder create 18 3 1" "main"

 swift-ring-builder object.builder create 18 3 1
 check_error "$?" "swift-ring-builder object.builder create 18 3 1" "main"

}


#=====================================================================================
#function main
#=====================================================================================
function main(){
if [ $# -eq 1 ]
then
	echo "#====================================================================="
	echo "#=================deploy swift proxy server==========================="
	echo "#====================================================================="
	echo ""

	echo "deploy start...."
	
        export auth_host=$1
        export BASE_DIR=$( pwd )

        set_local_env
#       configure_update_Repos
        install_swift
        install_memcached
        install_swift_proxyServer
        install_python_swiftclient
        install_python_keystoneclient
        config_proxy_log
	build_ring
else
        echo "params Error!"
        echo "you need to provide keystone auth server ip   as  param !"

fi
}


main "$@"

