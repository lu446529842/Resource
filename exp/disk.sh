#!/bin/bash

strArray=$( fdisk -l | grep "/dev/sd" |grep -v "sda" )
echo ${strArray}
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

echo ${disks}

for disk in ${disks}
  do
    echo ${disk}
  done
