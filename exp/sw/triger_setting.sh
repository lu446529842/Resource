#!/bin/bash

#=========================================================================================
#function       Expand swift cluster setting
#=========================================================================================
function expend_setting(){
 exend_version="swift_expend_frist"
 base_dir=$( pwd )
 expend_dir="${base_dir}/${exend_version}"
 expend_size=4

 if [ ! -d ${expend_dir} ]
 then
        mkdir ${expend_dir}
 fi
 STORAGE_LOCAL_NET_IP=192.168.2.35

 addcount=$( ls -l ${expend_dir} |wc -l )

 fullpath="${expend_dir}/${STORAGE_LOCAL_NET_IP}_${addcount}"
 touch ${fullpath}

 addcount=$( ls -l ${expend_dir} |wc -l )
 let "addcount=${addcount} - 1"
 echo "${addcount}"
 if [ ${addcount} -eq ${expend_size} ]
 then
        source ${base_dir}/rebalance_and_scp_ringfile.sh
 else
  echo "asdfasdf"
 fi


}

expend_setting
