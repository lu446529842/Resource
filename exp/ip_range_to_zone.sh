#!/bin/bash




#====================================================================
#function	set_zone_id_according_ip_range
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


set_zone_id
echo ${zone}

