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


#===================================================================================
#function	main
#===================================================================================
function main(){
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

main

