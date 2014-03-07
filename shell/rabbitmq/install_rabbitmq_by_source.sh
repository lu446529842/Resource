#########################################################################
# File Name: install_rabbitmq_by_source.sh
# Author: ldq
# mail: 446529842@qq.com
# Created Time: Sun 09 Feb 2014 08:53:59 PM CST
#########################################################################
#!/bin/bash

#=============================================
#function install dependency
#  各个集群上的erlang 版本要保持一致，集群上
#erlang.cookie 的值要相同，不然节点之间无法通信
#=============================================
function install_dependency(){
 yum install -y erlang

 erlang_cookie="IBGUUTZSCEAXEWIYQCRU_MAKE_IT"
 chmod 700 ~/.erlang.cookie
 echo ${erlang_cookie} > ~/.erlang.cookie
 chmod 400 ~/.erlang.cookie

 yum install -y xmlto
}


#=============================================
#function install  rabbitmq
#=============================================
function install_rabbitmq(){
 tarFile=${1}

 tar -zxvf ${tarFile}
 cd ${tarFile:0:21}
 echo $( pwd )

 make TARGET_DIR=/usr/local SBIN_DIR=/usr/local/sbin MAN_DIR=/usr/local/man install

 sleep 5 
 #安装web 界面  
 #输入http://server-name:55672/mgmt 进入监控界面
 mkdir /etc/rabbitmq
 rabbitmq-plugins enable rabbitmq_management
}


#=============================================
#function main
#=============================================
function main(){
 install_dependency

 install_rabbitmq ${1}
}

main "rabbitmq-server-3.1.4.tar.gz"
