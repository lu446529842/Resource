#!/bin/bash
#
#output log_info in a comom way
#
#all right reserved by ldq


#================================================================================================
#function:	cache error if cmd fail to execution
#================================================================================================
function cached_error(){

  cmd=$1
  func=$2
  
  ${cmd}
  status=$?
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
	echo "command ${cmd} in ${func}  execution Successfully!!"
  fi


}


#================================================================================================
#function:      check error if cmd fail to execution
#================================================================================================
function check_error(){

  
  cmd=$2
  func=$3
  status=$1

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
        echo "command ${cmd} in ${func}  execution Successfully!!"
  fi


}





function echo_demo(){
 echo "#======================================================================================="
 echo "#				just for fun					      ="
 echo "#======================================================================================="
 
 cached_error "ls -l" "echo_demo"
 cached_error "ssh root@9.1000.123.124" "echo_demo"


}


echo_demo
