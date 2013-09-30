#!/bin/sh


for ip in {20..30}
	do
		for disk in {b,c,d}
			do
				name="192.168.9.$ip"
				echo $name
			done
	done
