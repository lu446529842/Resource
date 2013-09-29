#!/bin/bash
#
#add  new devices to ring file
#
#all right reserved by ldq


#===================================================================================
#usage	run it in a proxy server
#	./xx.sh zone_id ip "sdb sdc sde" 
#===================================================================================


#=========================================================================================
#function	add new device according ZONE IP DISK
#=========================================================================================

function add_new_device(){
cd /etc/swift

echo "add new device to ring "
sleep 2
export WEIGHT=100               # relative weight (higher for bigger/faster disks)
export DEVICE=sdb


                for device in ${disks}
                        do
                                DEVICE=${device}
                                swift-ring-builder account.builder add z${ZONE}-${STORAGE_LOCAL_NET_IP}:6002/${DEVICE} ${WEIGHT}
                                swift-ring-builder container.builder add z${ZONE}-${STORAGE_LOCAL_NET_IP}:6001/${DEVICE} ${WEIGHT}
                                swift-ring-builder object.builder add z${ZONE}-${STORAGE_LOCAL_NET_IP}:6000/${DEVICE} ${WEIGHT}

                        done

}




#=========================================================================================
#function	main
#=========================================================================================
function main(){
if [ $# -eq  3 ]
then
 export ZONE=$1
 export disks="$3"
 export WEIGHT=100
 export DEVICE=sdb
 export STORAGE_LOCAL_NET_IP=$2


 swift-init proxy stop
 add_new_device

else
 echo "params error,expect 3 params!"
 echo "you should run this script with 3 params like :./xxx.sh zone_num ip \"sdb sdc sde\" "

fi

}

echo "#==============================================================="
echo "#=============add new device to swift cluster==================="
echo "#==============================================================="
echo ""

echo "start add new device!"
main "$@"

