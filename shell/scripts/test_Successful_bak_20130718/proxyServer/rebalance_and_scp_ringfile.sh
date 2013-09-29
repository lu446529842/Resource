#!/bin/bash
#rebalance ring and scp file to every storage node
#
#all right reserved by lu da quan (ludaquan@cn.ibm.com )
#

#ccount.builder========================================================================
#usage
#	./xxx.sh
#======================================================================================

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



#========================================================================
#function scp ring file to every storageNode
#========================================================================
function scp_file_storage(){
echo "start to scp ring file"
sleep 1
cd /etc/swift

ips=$( swift-ring-builder account.builder | grep "sd" |awk '{print $3}' |uniq )
for ip in $ips
        do
                echo "scp ring file to $ip"
                ssh -o StrictHostKeyChecking=no "root@$ip" "swift-init all stop; rm -rf /etc/swift/*.gz ;"
		check_error "$?" "ssh -o StrictHostKeyChecking=no \"root@$ip\" \"swift-init all stop; rm -rf /etc/swift/*.gz ;\""  "scp_file_storage"

                scp /etc/swift/*.gz  root@$ip:/etc/swift
		check_error "$1" "scp /etc/swift/*.gz  root@$ip:/etc/swift" "scp_file_storage"

                ssh  -o StrictHostKeyChecking=no  "root@$ip" "chown -R swift:swift /etc/swift;swift-init all start"
		check_error "$?" "ssh  -o StrictHostKeyChecking=no  \"root@$ip\" \"chown -R swift:swift /etc/swift;swift-init all start\"" "scp_file_storage"

                echo ""
        done



echo "finished!"
sleep 2
}



#=========================================================================================
#function       reblance ring
#=========================================================================================
function reblance_ring(){
echo "start reblance"
sleep 1
cd /etc/swift
chown -R swift:swift /etc/swift

echo "rebalance account.builder"
swift-ring-builder account.builder rebalance
check_error "$?" "swift-ring-builder account.builder rebalance" "reblance_ring"

echo "rebalance container.builder"
swift-ring-builder container.builder rebalance
check_error "$?" "swift-ring-builder container.builder rebalance" "reblance_ring"

echo "rebalance object.builder"
swift-ring-builder object.builder rebalance
check_error "$?" "swift-ring-builder object.builder rebalance" "reblance_ring"

echo ""
echo "finished !"
sleep 2
}


#=========================================================================================
#function verify cluster 
#=========================================================================================
function verify_cluster(){

count=$( swift-recon -l |grep http |wc -l )

if [ ${count} -ne 0  ]
then
 echo "something wrong with new expend cluster!"
 echo "#========================================================"
 echo $( swift-recon -l |grep http )
 echo "#========================================================"
else
 echo "swift cluster expend Successfully"
fi

}


#=========================================================================================
#function	set output log
#=========================================================================================
function set_log(){
   if [ ! -d /root/scripts/log ]
  then
        mkdir /root/scripts/log
  fi

  if [ ! -f /root/scripts/log/reblance.log ]
  then
        touch /root/scripts/log/reblance.log
  fi

  exec >> /root/scripts/log/reblance.log 2>&1
}

#=========================================================================================
#function	main function 
#=========================================================================================
function main(){
  
  reblance_ring
  scp_file_storage
  swift-init proxy start
  check_error "$?" "swift-init proxy start" "main"
  verify_cluster
  
}


set_log

echo "#==========================================================================="
echo "#start rebalance ring file scp to each storage node "
echo "# reblance time $( date +'%Y-%m-%d %H:%M:%S' )"
echo "#==========================================================================="
echo ""

echo "start reblance and scp"
sleep 2

main




