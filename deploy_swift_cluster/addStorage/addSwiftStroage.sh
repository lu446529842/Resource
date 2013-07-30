#!/bin/bash
#
#add a storage and triger proxy add device to the ring
#
#all right reserved by ldq


#====================================================================
#usage 
#	./xxx.sh param_1 param_2 
#	param_1 proxy server IP
#	param_2 a zone id 
#====================================================================

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


#====================================================================
# function	install swift
#====================================================================
function install_swift(){
echo "yum install openstack-swift"
sleep 1

yum install openstack-swift -y
check_error "$?" "yum install openstack-swift -y" "install_swift"

touch /etc/swift/swift.conf
cat ${BASE_DIR}/etc.conf/swift.conf > /etc/swift/swift.conf
sleep 1
}


#====================================================================
#function	set local ENV
#====================================================================

function set_local_env(){
echo "set local env"
sleep 1
export BASE_DIR=$( pwd )
STORAGE_LOCAL_NET_IP=$( ifconfig |grep "inet addr" |grep -v  "127.0.0.1"|cut -d: -f2|awk '{print $1}' )
export STORAGE_LOCAL_NET_IP

export cmd=" ${cmd} ${zone}  ${STORAGE_LOCAL_NET_IP} "
echo "finish !"
sleep 1

}

#====================================================================
#function	configure and update local Repos
#====================================================================

function configure_update_Repos(){
echo "configure a local yum Repos"
sleep 1

touch "/etc/yum.repos.d/rhel-epel.repo"

echo "[rhel-epel]" > /etc/yum.repos.d/rhel-epel.repo
echo "name=rhel eple" >> /etc/yum.repos.d/rhel-epel.repo
echo "baseurl=http://192.168.0.20/cobbler/others/epel6/x86_64/" >> /etc/yum.repos.d/rhel-epel.repo
echo "enable=1" >> /etc/yum.repos.d/rhel-epel.repo
echo "gpgcheck=0">> /etc/yum.repos.d/rhel-epel.repo
echo "priority=1" >> /etc/yum.repos.d/rhel-epel.repo

yum update 

sleep 1

}


#====================================================================
# function:	install and configure openstack-swift-account
#====================================================================

function install_swift_account(){
echo "install and configure openstack-swift-account"
sleep 1

yum install openstack-swift-account -y
check_error "$?" "yum install openstack-swift-account -y" "install_swift_account" 
sleep 1

echo "configure openstack-swift-account ....."
sleep 1


touch /etc/swift/account-server.conf
sed "s#<IP_ADDRESS>#${STORAGE_LOCAL_NET_IP}#g" ${BASE_DIR}/etc.conf/account-server.conf > /etc/swift/account-server.conf


echo "complete !"
sleep 1
}

#====================================================================
# function	install and configure openstack-swift-container
#====================================================================

function install_swift_container(){
echo "install and configure openstack-swift-container"
sleep 1

yum install openstack-swift-container -y
check_error "$?" "yum install openstack-swift-container -y" "install_swift_container"

echo "configure openstack-swift-container...."
sleep 1

touch /etc/swift/container-server.conf
sed "s#<IP_ADDRESS>#${STORAGE_LOCAL_NET_IP}#g" ${BASE_DIR}/etc.conf/container-server.conf > /etc/swift/container-server.conf
echo "finished!"
sleep 1

}


#====================================================================
# function	install and configure openstack-swift-object
#====================================================================

function install_swift_object(){
echo "install and configure openstack-swift-object"
sleep 1

yum install openstack-swift-object -y
check_error "$?" "yum install openstack-swift-object -y" "install_swift_object"

echo "configure openstack-swift-object...."
sleep 1

touch  /etc/swift/object-server.conf
sed "s#<IP_ADDRESS>#${STORAGE_LOCAL_NET_IP}#g" ${BASE_DIR}/etc.conf/object-server.conf > /etc/swift/object-server.conf
echo "finished!"
sleep 1


}



#====================================================================
#function	install and configure  xfsprogs
#====================================================================

function install_xfsprogs(){
echo "install  xfsprogs"
sleep 1

yum install xfsprogs -y
check_error "$?" "yum install xfsprogs -y" "install_xfsprogs"
echo "finished!"
sleep 1
}



#====================================================================
#function	format and mount disk
#====================================================================

function format_mount_disk(){
echo "format and mount disk"
sleep 1


#get disk list 
strArray=$( fdisk -l | grep "/dev/sd" |grep -v "sda" )
disks[0]=""
diskCount=0

for disk in ${strArray}
        do
                i=${#disk}
                if [ $i -eq 9 ]
                then
                        disks[${diskCount}]=${disk:5:3}
                        let "diskCount=${diskCount} + 1"
                fi

        done

#start to format and mount
for disk in ${disks[@]}
        do
                mkfs.xfs -f  -i size=1024 /dev/${disk}
		check_error "$?" "mkfs.xfs -f  -i size=1024 /dev/${disk}" "format_mount_disk"
                echo "/dev/${disk} /srv/node/$disk xfs noatime,nodiratime,nobarrier,logbufs=8 0 0" >> /etc/fstab
                mkdir -p /srv/node/${disk}
                mount /srv/node/${disk}
        done

chown -R swift:swift /srv/node

echo "finished !"
sleep 1


}


#====================================================================
#function	configure rsyncd
#====================================================================
function configure_rsyncd(){
echo "configure rsyncd"

touch /etc/rsyncd.conf
sed "s#<IP_ADDRESS>#${STORAGE_LOCAL_NET_IP}#g" ${BASE_DIR}/etc.conf/rsyncd.conf > /etc/rsyncd.conf
echo "finished !"

sleep 1
}



#====================================================================
#function	triger proxy server
#====================================================================

function triger_proxyServer(){
echo "triger proxy server "
sleep 1

expect -c "     spawn ssh -o StrictHostKeyChecking=no root@${proxy_IP}  ${cmd};
                 expect {
                    *assword:* {send -- ${password}\r;
                                 expect {
                                    *denied* {exit 1;}
                                    eof
                                 }
                    }
    
                        eof         {exit 1;}
                }
                "

echo "finished!"
sleep 1

}



#====================================================================
#function	configure swift storage log
#====================================================================

function swift_storage_log(){
echo "configure swift storage log" 
sleep 1

touch /etc/rsyslog.d/swift.conf

echo "local1,local2,local3.*   /var/log/swift/all.log" > /etc/rsyslog.d/swift.conf
echo "local1.*   /var/log/swift/object.log" >> /etc/rsyslog.d/swift.conf
echo "local2.*   /var/log/swift/container.log" >> /etc/rsyslog.d/swift.conf
echo "local3.*   /var/log/swift/account.log" >> /etc/rsyslog.d/swift.conf

mkdir -p /var/log/swift
service rsyslog restart
check_error "$?" "service rsyslog restart" "swift_storage_log"

echo "finished!"
sleep 1

}


#====================================================================
#function mkdir swift recon cache 
#====================================================================
function swift_recon(){
echo "create /var/cache/swift!"
sleep 1

mkdir /var/cache/swift

chown swift:swift /var/cache/swift

echo "finished !"
sleep 1
}


#====================================================================
#function	rmdir .ssh if exist 
#====================================================================
function rmdir_ssh(){
echo "rmdir /root/.ssh"
sleep 1

if [ -d /root/.ssh ]
then
	rm -rf /root/.ssh
fi

}

#========================================================================
#function       intall expect
#========================================================================
function install_expect(){
echo "install expect"
sleep 2
yum install expect -y

}

#====================================================================
#function       set_zone_id_according_ip_range
#====================================================================
function set_zone_id(){
 host_ip=$( ifconfig |grep "inet addr" |grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}' )
 sub="."
 replace=" "
 Suffix=${host_ip//$sub/$replace}
 Suffix=$( echo ${Suffix} | awk '{print $4}' )

 zone=0

 start_1=10
 end_1=20

 start_2=21
 end_2=30

 start_3=31
 end_3=40

 start_4=41
 end_4=50

 if [ ${Suffix} -ge ${start_1} ] && [ ${Suffix} -le ${end_1} ]
 then
        zone=1
 elif [ ${Suffix} -ge ${start_2} ] && [ ${Suffix} -le ${end_2} ]
 then
        zone=2
 elif [ ${Suffix} -ge ${start_3} ] && [ ${Suffix} -le ${end_3} ]
 then
        zone=3
 else
        zone=4
 fi

export zone

}


#====================================================================
#function set output log
#====================================================================
function set_log(){
	if [ ! -d /root/scripts/log ]
        then
                mkdir /root/scripts/log
        fi

        if [ ! -f /root/scripts/log/storage.log ]
        then
                touch /root/scripts/log/storage.log
        fi

        exec > /root/scripts/log/storage.log 2>&1

}
 
#====================================================================
#function	main
#====================================================================
function main(){
	set_log
	echo "#================================================================"
	echo "#==========add new storage to swift device to swift cluster======"
	echo "#================================================================"
	echo ""

	echo "start to deploy"
        export proxy_IP="9.123.124.203"
        export password="123"
        export cmd="/root/scripts/reconfig_ring.sh"

        export  expect=$( ls /usr/bin |grep -w expect )
        if [ "$expect" != "expect" ]
        then
                echo "there is no expect!"
                install_expect
        fi
	
 	set_zone_id
        set_local_env
#        configure_update_Repos
        install_swift
        install_swift_account
        install_swift_container
        install_swift_object
        install_xfsprogs
        configure_rsyncd
        format_mount_disk
        swift_storage_log
        swift_recon
        rmdir_ssh
        triger_proxyServer
}


main

