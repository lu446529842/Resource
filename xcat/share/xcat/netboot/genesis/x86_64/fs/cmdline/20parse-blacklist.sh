#!/bin/sh

for i in $(getargs rdblacklist=); do 
    (
        IFS=,
	for p in $i; do 
            echo "blacklist $p" >> /etc/modprobe.d/initramfsblacklist.conf
	done
    )
done
