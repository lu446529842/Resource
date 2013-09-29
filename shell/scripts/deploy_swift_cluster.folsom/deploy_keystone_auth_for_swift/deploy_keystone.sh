#!/bin/bash
#
#deploy a keystone service and create some tenants role user servce-endpoint 
#
#all right reserved by ldq

#================================================================================================
#usage  
#	`./xxx.sh swift_proxy_ip
#================================================================================================



#================================================================================================
#function:      check error if cmd fail to execution
#================================================================================================
function check_error(){

  status=$1
  cmd1=$2
  func=$3

  if [ ${status} -ne 0 ]
  then

          time_info=$( date +'%Y-%m-%d %H:%M:%S' )
          error_info="command ${cmd1} fail ro execution  in function  ${func} ,exit status :${status} "
          echo ""
          echo "#===============ERROR LOG==============================================================="
          echo "#=   error_time: ${time_info}"
          echo "#=   error_info: ${error_info}"
          echo "#======================================================================================="
          echo ""
  else
          echo "#======================================================================================="
          echo "command ${cmd1}   in function  ${func}  execution Successfully!!"
          echo "#======================================================================================="
        echo ""
  fi


}


#=====================================================================================================
#function	set env
#=====================================================================================================
function set_env(){
 export LOACL_ADDRESS=$( ifconfig |grep "inet addr" |grep -v  "127.0.0.1"|cut -d: -f2|awk '{print $1}' )
}


#=====================================================================================================
#function	install packages service
#=====================================================================================================
function install_packages_service(){
 packages="$@"
 
 for package in ${packages}
	do
		yum install -y --nogpgcheck ${package}
		check_error "$?" "yum install -y --nogpgcheck ${package}" "install_packages_service"
	done
}



#=====================================================================================================
#fucntion	 install keystone server
#=====================================================================================================
function install_keystone_server(){
 install_packages_service  openstack-utils openstack-keystone python-keystoneclient
 
}



#=====================================================================================================
#function	config keystone 
#=====================================================================================================
function config_keystone(){
#  openstack-db --init --service keystone

  # creating database for keystone
    mysql  -u root -ppassw0rd -e 'CREATE DATABASE keystone;'
    mysql  -u root -ppassw0rd  -e "GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone';"
    mysql  -u root -ppassw0rd  -e "GRANT ALL ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'keystone';"
    mysql  -u root -ppassw0rd  -e " FLUSH PRIVILEGES;"

  export ADMIN_TOKEN=$(openssl rand -hex 10)
  openstack-config --set /etc/keystone/keystone.conf DEFAULT admin_token ${ADMIN_TOKEN}
  service openstack-keystone start &&  chkconfig openstack-keystone on
  keystone-manage db_sync
}

#=====================================================================================================
#function	install mysql server 
#=====================================================================================================
function install_mysql_server(){
  install_packages_service mysql mysql-server MySQL-python

  chkconfig --level 2345 mysqld on
  service mysqld start
  check_error "$?"  "service mysqld start" 

  mysqladmin -u root password passw0rd
  check_error "$?" "mysqladmin -u root password passw0rd" "install_mysql_server"
  
}


#=====================================================================================================
#function	get tenant id
#=====================================================================================================
function get_id(){
tenant_id=$( keystone --token ${ADMIN_TOKEN}  --endpoint http://${LOACL_ADDRESS}:35357/v2.0 $3 | grep "$1" | awk '{print $2}' )
env="export $2=$tenant_id"
${env}
}


#=====================================================================================================
#function create tenant user service  endpoint
#=====================================================================================================
function create_admin_and_swift_service(){
#create tenant
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 tenant-create --name admin --description "admin Tenant"
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 tenant-create --name service --description "service Tenant"

#set tenant_id
get_id admin ADMIN_TENANT_ID tenant-list
get_id service SERVICE_TENANT_ID tenant-list

#create user 
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 user-create --tenant-id ${ADMIN_TENANT_ID}  --name admin --pass admin
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 user-create --tenant-id ${SERVICE_TENANT_ID}  --name swift --pass swift

#set user id 
get_id admin ADMIN_USER_ID user-list
get_id swift SWIFT_USER_ID user-list

#create role 
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 role-create --name admin
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 role-create --name Member

#set root id
get_id admin ADMIN_ROLE_ID role-list

#grant role to user 
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 user-role-add --user-id ${SWIFT_USER_ID} --tenant-id ${SERVICE_TENANT_ID} --role-id ${ADMIN_ROLE_ID}
keystone --token  ${ADMIN_TOKEN} --endpoint http://${LOACL_ADDRESS}:35357/v2.0 user-role-add --user-id ${ADMIN_USER_ID} --tenant-id ${ADMIN_TENANT_ID} --role-id ${ADMIN_ROLE_ID}


#SET UP SERVICE ENDPOINT

#set up keystone service endpoint
keystone --token ${ADMIN_TOKEN} \
 --endpoint http://${LOACL_ADDRESS}:35357/v2.0/ \
 service-create \
 --name=keystone \
 --type=identity \
 --description="Keystone Identity Service"

get_id  keystone KEYSTONE_SERVICE_ID  service-list

keystone --token ${ADMIN_TOKEN}  \
 --endpoint http://${LOACL_ADDRESS}:35357/v2.0/ \
 endpoint-create \
 --region RegionOne \
 --service-id=${KEYSTONE_SERVICE_ID} \
 --publicurl=http://${LOACL_ADDRESS}:5000/v2.0 \
 --internalurl=http://${LOACL_ADDRESS}:5000/v2.0 \
 --adminurl=http://${LOACL_ADDRESS}:35357/v2.0

#set swift service endpoint
keystone --token ${ADMIN_TOKEN}  \
 --endpoint http://${LOACL_ADDRESS}:35357/v2.0/ \
 service-create \
 --name=swift \
 --type=object-store \
 --description="Object Storage Service"

get_id swift SWIFT_SERVICE_ID service-list


 keystone --token ${ADMIN_TOKEN} \
 --endpoint http://${LOACL_ADDRESS}:35357/v2.0/ \
 endpoint-create \
 --region RegionOne \
 --service-id=${SWIFT_SERVICE_ID} \
 --publicurl "http://${SWIFT_PROXY_IP}:8080/v1/AUTH_%(tenant_id)s" \
 --adminurl "http://${SWIFT_PROXY_IP}:8080/v1" \
 --internalurl "http://${SWIFT_PROXY_IP}:8080/v1/AUTH_%(tenant_id)s"
}

#====================================================================
#function set output log
#====================================================================
function set_log(){

  BASE_DIR= $( pwd )
  fullPath=$(BASE_DIR)/log/keystone_install.log
  if [ ! -d $(BASE_DIR)/log/ ]
  then
      mkdir $(BASE_DIR)/log
  fi

  if [ ! -f ${fullPath} ]
  then
         touch ${fullPath}
  fi

  exec > ${fullPath} 2>&1

}


#=====================================================================================================
#function	main
#=====================================================================================================
function main(){
 if [ $# -eq 1 ] 
 then
 export SWIFT_PROXY_IP=$1
 
 set_log
 set_env 
 install_keystone_server 
 install_mysql_server
 config_keystone
 create_admin_and_swift_service
 else
  echo "input params error!"
  echo "expect one param,you should use this scripts like ./xxx.sh SWIFT_PROXY_IP"
  echo "here is a sample:./xxxx.sh 192.168.2.31"
 fi
}

main "$@"
