#!/bin/sh
#
#configure swift cluster ssh login without password
#
#this scripts should be run in the proxyServer

#========================================================================
#function	configure_ssh
#========================================================================
function configure_ssh(){
echo "create ssh key"
sleep 2
cd ~/.ssh
ssh-keygen -t rsa

touch  ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

}




#========================================================================
#function	intall expect
#========================================================================
function install_expect(){
echo "install expect"
sleep 2
yum install expect -y

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

echo "start to scp ring file"
sleep 1
cd /etc/swift
ips=$( swift-ring-builder account.builder | grep "sd" |awk '{print $3}' |uniq )
for ip in $ips
	do
		auto_mkdir "${password}" "root@${ip}" "rm -rf /root/.ssh"
		auto_mkdir "${password}" "root@${ip}" "mkdir /root/.ssh"
		auto_scp  "${password}"   "/root/.ssh/authorized_keys" "root@${ip}:/root/.ssh/"
	done



echo "finished!"
sleep 2
}

#========================================================================
#function	main
#========================================================================
function main(){
if [ $# -eq 1  ]
then
	echo "#=============================================================================="
	echo "#=================configure swift cluster ssh  without password================"
	echo "#=============================================================================="
	echo ""

	echo "start configure..."

        password=$1
        export password
        export  expect=$( ls /usr/bin |grep -w expect )
        if [ "${expect}" != "expect" ]
        then
                echo "there is no expect!"
                install_expect
        fi

        configure_ssh
        scp_ssh_key

else
        echo "params number wrong,you should run this script with a password param"
fi
}



main "$@"

