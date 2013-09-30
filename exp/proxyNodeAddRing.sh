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
#function   get zone,ip and device 
#=========================================================================================
function set_zone_ip(){
 ipStart = ${1}
 ipEnd = ${2}
 ipPrefix = ${3}

 for ip in `seq ${ipStart} ${ipEnd}`
        do
		ZONE=`expr ${ip} % 5`
		export ZONE 
		STORAGE_LOCAL_NET_IP="${ipPrefix}${ip}"
		export STORAGE_LOCAL_NET_IP
		add_new_device
        done
}

#=========================================================================================
#function	main
#=========================================================================================
function main(){
 ipStart=<%= node["storageIpStart"] %>
 ipEnd=<%= node["storageIpEnd"] %>
 prefix=<%= node["storageIpPrefix"]%>
 disks=<%= node["diskArray"]%>
 export disks

 swift-init proxy stop
 set_zone_ip ${ipStart} ${ipEnd} ${prefix}
}

main
