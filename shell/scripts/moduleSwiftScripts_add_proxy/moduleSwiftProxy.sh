#!/bin/bash
#
#install openstack folsom swift proxy node 
#
#all right reserved by lu da quan (ludaquan@cn.ibm.com)
#
#

#====================================================================
#usage
# ./moduleSwiftProxy.sh param_1 params_2
# param_1 is a keystone auth server IP
# param_2 is a proxy server ip in swift cluster
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

#========================================================================
#function       intall expect
#========================================================================
function install_expect(){
echo "install expect"
sleep 2
yum install expect -y

}

#========================================================================
#function auto scp 
#========================================================================
auto_scp () {
    expect -c "set timeout -1;
                spawn scp -o StrictHostKeyChecking=no ${@:2};
                expect {
                    *assword:* {send -- $1\r;
                                 expect {
                                    *denied* {exit 1;}
                                    eof
                                 }
                    }
                    eof         {exit 1;}
                }
                "
    return $?
}

#=====================================================================================
#function scp ring file from other proxyserver
#=====================================================================================
function scp_ring_file_from_proxy(){
echo "scp file from proxyserver"
sleep 2
auto_scp "${password}" "root@${proxy_host}:/etc/swift/*.gz" "/etc/swift"
chown -R swift:swift /etc/swift
}

if [ $# -eq 2 ]
then
	export auth_host=$1
	export proxy_host=$2
	export BASE_DIR=$( pwd )
	export password="123"
	
	export  expect=$( ls /usr/bin |grep -w expect )
        if [ "$expect" != "expect" ]
        then
                echo "there is no expect!"
                install_expect
        fi

	
	set_local_env
#	configure_update_Repos
	install_swift
	install_memcached
	install_swift_proxyServer
	install_python_swiftclient
	install_python_keystoneclient
	config_proxy_log
	scp_ring_file_from_proxy
	swift-init proxy start
else
	echo "params Error!"
	echo "you need to provide keystone auth server ip and a proxy server ip  as  params !"

fi
