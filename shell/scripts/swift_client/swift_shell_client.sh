#!/bin/bash
#
#swift operation api 
#
#

#=================================================================================
#funciont
#=================================================================================


#=================================================================================
#function	set up tenant_id and token_id
#=================================================================================
function setup_tenant_and_token(){
# export tenantName=service
# export username=swift
# export password=swift
 export SWIFT_IP_ADDRESS=9.123.124.203
 export KEYSTONE_AUTH_IP=9.123.124.60

 banlk=" "

 reslut=$( curl -s  -X POST -d '{"auth": {"tenantName": "service", "passwordCredentials":{"username": "swift", "password": "swift"}}}' -H "Content-type: application/json" http://${KEYSTONE_AUTH_IP}:5000/v2.0/tokens )
 result_parse=$( echo ${reslut} | sed -e "s#{#${banlk}#g" -e "s#}#${banlk}#g" -e "s#,#${banlk}#g" -e "s#\"#${banlk}#g" -e "s#:#${banlk}#g" )
 token_id=$(  echo ${result_parse} | awk '{print $8}' )
 tenant_id=$( echo ${result_parse} | awk '{print $18}')
 export token_id
 export tenant_id

}



#=================================================================================
#functiong	get container list
#=================================================================================
function get_container_list(){
  curl  http://${SWIFT_IP_ADDRESS}:8080/v1/AUTH_${tenant_id} -X GET -H "X-Auth-Token: ${token_id}"
}


#=================================================================================
#function	create container
#=================================================================================
function create_container(){
 containername=$1
 c_reslut=$( curl -s  http://${SWIFT_IP_ADDRESS}:8080/v1/AUTH_${tenant_id}/${containername} -X PUT -H "X-Auth-Token: ${token_id}")
 echo "${c_reslut}"
 get_container_list
}


#=================================================================================
#function	delete container
#=================================================================================
function delete_container(){
 containername=$1
 curl  http://${SWIFT_IP_ADDRESS}:8080/v1/AUTH_${tenant_id}/${containername} -X DELETE -H "X-Auth-Token: ${token_id}"
 get_container_list
}


#=================================================================================
#function	list container object
#=================================================================================
function list_container_object(){
 containername=$1
 curl  http://${SWIFT_IP_ADDRESS}:8080/v1/AUTH_${tenant_id}/${containername} -X GET -H "X-Auth-Token: ${token_id}"
}


#=================================================================================
#function	create object
#=================================================================================
function create_object(){
 containername=$1
 objectname=$2
 curl  -X PUT -i -H "X-Auth-Token: ${token_id}" -T ${objectname}  http://${SWIFT_IP_ADDRESS}:8080/v1/AUTH_${tenant_id}/${containername}/${objectname##*/}
 list_container_object ${containername}
}


#=================================================================================
#function delete object 
#=================================================================================
function delete_object(){
 containername=$1
 objectname=$2
 curl -X DELETE -i -H "X-Auth-Token: ${token_id}"   http://${SWIFT_IP_ADDRESS}:8080/v1/AUTH_${tenant_id}/${containername}/${objectname}
 echo ""
 list_container_object ${containername}

}

#=================================================================================
#function Retrieve a object 
#st_container_object=================================================================================
function retrieve_object(){
 containername=$1list_container_object
 objectname=$2
 curl  -X GET -i -H "X-Auth-Token: ${token_id}"   http://${SWIFT_IP_ADDRESS}:8080/v1/AUTH_${tenant_id}/${containername}/${objectname} > ${objectname}

}


#=================================================================================
#function usage
#=================================================================================
function usage(){
 cat << EOF
 ================================================================================
 #help function
 ================================================================================
 
 usage:		./xx.sh -option [containname] [objectname]
 -c		create ,create a contain or object
		sample: ./xx.sh -c container_name	or	./xx.sh -c container_name object_fullpath
 -l		list,list all container or all object in specific container
		sample:./xx.sh -l	or	./xx.sh -l container_name
 -d		delete,delete a container or object
		sample:./xx.sh -d container_name	or	./xx.sh	-d container_name  object_name

  -r		retrieve,get a object	
		sample:./xx.sh -r container_name object_name
 -h		help ,show this usage function
EOF
}
#=================================================================================
#function	main
#=================================================================================
function main(){
 setup_tenant_and_token
 if [ $# -eq 1 ]
 then
   if [ "$1" == "-l" ]
   then
	get_container_list
   else
	usage
   fi
 elif [ $# -eq 2 ]
 then

   case "$1" in
	"-c")
		create_container $2
 	;;
 	"-d")
		delete_container $2
	;;
	"-l")
		list_container_object $2
	;;
	*)
		usage
	;;
    esac
		
 elif [ $# -eq 3 ]
 then
   case "$1" in
	"-c")
		create_object $2 $3
	;;
	"-d")
		delete_object $2 $3
	;;
	"-r")
		retrieve_object $2 $3
	;;
	*)
		usage
	;;
   esac
 else
	usage
 fi
 
}

main "$@"
