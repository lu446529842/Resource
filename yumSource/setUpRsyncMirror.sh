#########################################################################
# File Name: setUpRsyncMirror.sh
# Author: ldq
# mail: 446529842@qq.com
# Created Time: Thu 28 Nov 2013 05:26:57 AM CST
#########################################################################
#!/bin/bash

#===========================================
#function mkdir yum source
#===========================================
function setUpSource()
{
	server=${1}
	des=${2}

	rsync -avzP --delete ${server} ${des}
}


#===========================================
#function setup repo
#===========================================
function setUp()
{
	title=${1}
	path=${2}
	repoName=${3}
	fileName=${4}

	touch /etc/yum.repos.d/${fileName}

	echo "[${title]"  > /etc/yum.repos.d/${fileName}
	echo "name=${repoName}" >> /etc/yum.repos.d/${fileName}
	echo "baseurl=file:///${path}" >> /etc/yum.repos.d/${fileName}
	echo "enable=1" >> /etc/yum.repos.d/${fileName}
	echo "gbcheck=0"
}


#===========================================
#function main
#===========================================
function main()
{

}

main "$@"
