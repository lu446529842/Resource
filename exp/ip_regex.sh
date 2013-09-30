#!/bin/sh

start=$1
end=$2

for ip in `seq $start $end`
	do
		echo "$ip"
	done

dir=$( pwd )
source ${dir}/ip_range_to_zone.sh
