#!/bin/bash

yum remove -y openstack-swift openstack-swift-account openstack-swift-container openstack-swift-object  xfsprogs openstack-swift-proxy




#get disk list 
strArray=$( fdisk -l | grep "/dev/sd" |grep -v "sda" )
disks[0]=""
diskCount=0

for disk in $strArray
        do
                i=${#disk}
                if [ $i -eq 9 ]
                then
                        disks[$diskCount]=${disk:5:3}
                        let "diskCount=$diskCount + 1"
                fi

        done


for disk in ${disks[@]}
        do
                umount /dev/$disk
        done

rm -rf /srv/node
rm -rf /root/.ssh
rm -rf /var/log/swift
rm -rf /etc/swift
rm -rf /var/cache/swift
