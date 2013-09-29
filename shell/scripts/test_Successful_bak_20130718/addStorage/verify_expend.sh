#!/bin/bash


count=$( swift-recon -l |grep http |wc -l )

if [ ${count} -ne 0  ]
then
 echo "something wrong with new expend cluster!"
 echo "#========================================================"
 echo $( swift-recon -l |grep htt )
 echo "#========================================================"
else
 echo "swift cluster expend Successfully"
fi

