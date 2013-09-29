#!/bin/bash
#configure ssh public key  to a storage and  add new devices into ring file
#
#all right reserved by lu da quan (ludaquan@cn.bim.com)
#


#========================================================================
#usage		this script should be run on a swift  proxy server
# 		there are two way to run it
# frist:
#	./xx.sh zone_id  storage_ip like  ./xx.sh 1 192.168.2.41
#second:
#	copy it to a proxy server in /root/scripts dir,triger it 
#	when add a new storage node
# 
#========================================================================


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

#========================================================================
#function  mkdir .ssh folder
#========================================================================
auto_mkdir () {
    expect -c "set timeout -1;
                spawn ssh -o StrictHostKeyChecking=no  ${@:2};
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



#========================================================================
#function scp public key storageNode
#========================================================================
function scp_ssh_key(){

echo "start to scp ssh key  file"
sleep 1

		auto_scp  "${password}"   "/root/.ssh/authorized_keys" "root@${STORAGE_LOCAL_NET_IP}:/root/.ssh"
		check_error "$?" "auto_scp  \"${password}\"   \"/root/.ssh/authorized_keys\" \"root@${STORAGE_LOCAL_NET_IP}:/root/.ssh\"" "scp_ssh_key"


echo "finished!"
sleep 2
}




#=========================================================================================
#function       add new device according ZONE IP DISK
#=========================================================================================

function add_new_device(){
 export disks="sdb"
 export WEIGHT=100
 export DEVICE=sdb



cd /etc/swift

echo "add new device to ring "
sleep 2


for device in ${disks}
	do
            DEVICE=${device}
            swift-ring-builder account.builder add z${ZONE}-${STORAGE_LOCAL_NET_IP}:6002/${DEVICE} ${WEIGHT}
            swift-ring-builder container.builder add z${ZONE}-${STORAGE_LOCAL_NET_IP}:6001/${DEVICE} ${WEIGHT}
            swift-ring-builder object.builder add z${ZONE}-${STORAGE_LOCAL_NET_IP}:6000/${DEVICE} ${WEIGHT}
        done

}

#=========================================================================================
#function	backup ring file 
#=========================================================================================
function backup_ring_file(){
 echo "back ring file then add new driver"
 sleep 2

 mkdir /etc/swift/backups/backup_${STORAGE_LOCAL_NET_IP}
 check_error "$?" "mkdir /etc/swift/backups/backup_${STORAGE_LOCAL_NET_IP}" "backup_ring_file"

 cp /etc/swift/*.gz /etc/swift/backups/backup_${STORAGE_LOCAL_NET_IP}
 check_error "$?" "/etc/swift/backups/backup_${STORAGE_LOCAL_NET_IP}" "backup_ring_file"

 cp /etc/swift/*.builder /etc/swift/backups/backup_${STORAGE_LOCAL_NET_IP}
 check_error "$?" "cp /etc/swift/*.builder /etc/swift/backups/backup_${STORAGE_LOCAL_NET_IP}" "backup_ring_file"
 echo "backup finished!"
 echo ""

}



#=========================================================================================
#function       Expand swift cluster setting
#=========================================================================================
function expend_setting(){
 exend_version="swift_expend_frist"
 expend_dir="${BASE_DIR}/${exend_version}"
 expend_size=4

 if [ ! -d ${expend_dir} ]
 then
        mkdir ${expend_dir}
 fi

 addcount=$( ls -l ${expend_dir} |wc -l )

 fullpath="${expend_dir}/${STORAGE_LOCAL_NET_IP}_${addcount}"
 touch ${fullpath}

 addcount=$( ls -l ${expend_dir} |wc -l )
 let "addcount=${addcount} - 1"
 if [ ${addcount} -eq ${expend_size} ]
 then
        source ${BASE_DIR}/rebalance_and_scp_ringfile.sh
 else
	echo "l do not triger  rebalance_and_scp_ringfile.sh" > ${fullpath}
 fi


}



#=========================================================================================
#function set output log
#=========================================================================================
function set_log(){
	if [ ! -d /root/scripts/log ]
        then
          mkdir /root/scripts/log
        if
        touch /root/scripts/log/${STORAGE_LOCAL_NET_IP}.log
        exec >/root/scripts/log/${STORAGE_LOCAL_NET_IP}.log  2>&1
}
#=========================================================================================
#function	main
#=========================================================================================
function main(){
if [ $# -eq 2 ]
then
        export password="time4fun"
        export ZONE=$1
        export STORAGE_LOCAL_NET_IP=$2
	export BASE_DIR="/root/scripts"

        swift-init proxy stop
        backup_ring_file
        scp_ssh_key
        add_new_device
        expend_setting


else
        echo "params number wrong,you should run this script with a zone_id and a storage ip address!! "
fi
}


set_log

echo "#================================================================"
echo "#===============reconfig ring file =============================="
echo "#================================================================"
echo ""

echo "start to config"

main "$@"


