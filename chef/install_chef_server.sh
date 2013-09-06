#!/bin/bash
#
#deploy chef server
#
#by ldq

#========================================================
#function	install chef server
#========================================================
function install_chef_server(){
 # install package
 rpm -hiv chef-server-11.0.8-1.el6.x86_64.rpm 

 # config chef server 
 chef-server-ctl reconfigure
  
}



#========================================================
#function	set up workstation
#========================================================
function set_up_workstation(){
 #install chef-client server
 rpm -hiv chef-11.4.4-2.el6.x86_64.rpm

 # clone chef-repo from github
 cd ~
 git clone git://github.com/opscode/chef-repo.git

 # create .chef dir
 mkdir -p ~/chef-repo/.chef

 cd chef-repo
 cat .gitignore .chef

 #config workstation
 # default https://ip   no port
 # .pem file in /etc/chef-server
 knife configure --initial
 
 knife client list

}


