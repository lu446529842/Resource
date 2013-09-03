#!/bin/bash
#PXE+DHCP+TFTP+KickStart delpoy redhat system
#

#=================================================
#function install all require  package
#=================================================
function install_require_package(){
 yum install -y  dhcp tftp-server nfs-utils syslinux vsftpd
}


#=================================================
#function	config dhcp.conf
#=================================================
function config_dhcp(){
 sed -e "s#<SUBNET>#${subnet}#g" -e "s#<RANGE_START>#${range_start}#g" -e "s#<RANGE_END>#${range_end}#g" -e "s#<FTP_SETVER>#${ftp_server}#g" ${BASE_DIR}/dhcpd.conf > /etc/dhcp/dhcpd.conf
 service dhcpd start
}



#=================================================
#function config ftp 
#=================================================
function config_ftp(){
 cat ${BASE_DIR}/tftp > /etc/xinetd.d/tftp
 service xinetd restart
}


#=================================================
#function prepare for image
#=================================================
function prepare_image(){
 mkdir /var/ftp/pub/rhel6
 mkdir /tmp/ISO
 mount -t iso9660 -o loop ${ISO_DIR} /tmp/ISO
 echo "COPY ISO IMAGE TO /VAR/FTP/PUB DIR .PLS WAIT ...."
 cp -R /tmp/ISO /var/ftp/pub/rhel6
 cd /var/ftp/pub/rhel6 
 mv ISO/* .
 rm -rf ISO

 cd /var/lib/tftpboot/
 cp -a /var/ftp/pub/rhel6/isolinux/* .
 mkdir pxelinux.cfg
 sed "s#<FTP_SERVER>#${ftp_server}#g"  ${BASE_DIR}/default > /var/lib/tftpboot/pxelinux.cfg/default
}


#=================================================
#function	config kickstart
#=================================================
function config_kickstart(){
 sed "s#<FTP_SERVER>#${ftp_server}#g" ${BASE_DIR}/ks.cfg >  /var/ftp/pub/ks.cfg
 chmod 644 /var/ftp/pub/ks.cfg
 cp /usr/share/syslinux/pxelinux.0  /var/lib/tftpboot/
 
 service vsftpd restart
 service dhcpd restart
 service xinetd restart
}



#=================================================
#function main
#=================================================
function main(){
 export BASE_DIR=$( pwd )
 export ISO_DIR=""
 export subnet=9.123.124.0
 export range_start=9.123.124.2
 export range_end=9.123.124.250
 export ftp_server=$( ifconfig eth0  |grep "inet addr" |grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}' )
 
 install_require_package
 config_dhcp
 config_ftp
 prepare_image
 config_kickstart
}
