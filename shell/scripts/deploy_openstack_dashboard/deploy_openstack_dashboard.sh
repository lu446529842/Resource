#!/bin/bash

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
        echo "command ${cmd1}   in function  ${func}  execution Successfully!!"
        echo ""
  fi


}


#================================================================================================
#function set output log
#================================================================================================
function set_log(){
        if [ ! -d ${BASE_DIR}/log ]
        then
                mkdir ${BASE_DIR}/log
        fi

        if [ ! -f ${BASE_DIR}/log/storage.log ]
        then
                touch ${BASE_DIR}/log/storage.log
        fi

        exec > ${BASE_DIR}/log/storage.log 2>&1

}

#================================================================================================
#function install git-core
#================================================================================================
function install_git_core(){
 yum install -y git-core
 check_error "$?" "yum install -y git-core" "install_git_core"
}

#================================================================================================
#function install openstack dashboard
#================================================================================================
function install_openstack_dashboard(){
  yum install -y memcached python-memcached mod_wsgi openstack-dashboard
  check_error "$?" "yum install -y memcached python-memcached mod_wsgi openstack-dashboard" "nstall_openstack_dashboard"

#config dashboard
 sed "s#<KEYSTONE_HOST>#${KEYSTONE_HOST}#g" ${BASE_DIR}/local_settings > /etc/openstack-dashboard/local_settings
}


#================================================================================================
#function	start service
#================================================================================================
function start_service(){
 /etc/init.d/httpd restart
 check "$?" "/etc/init.d/httpd restart" "start_service"


 /etc/init.d/memcached restart
 check "$?" "/etc/init.d/memcached restart" "start_service"
}


#================================================================================================
#function	main
#================================================================================================
function main(){
 set_log 
 export BASE_DIR=$( pwd )
 if [ ${#} -ne 1 ]
 then
	echo "start_serviceexpect keystone host ip as input params!!"
	exit
 fi
 
 export KEYSTONE_HOST=${1}
 
 install_git_core
 install_openstack_dashboard
 start_service
 
}

