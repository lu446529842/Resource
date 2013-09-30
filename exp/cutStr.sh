#!/bin/sh

str="Disk /dev/sde: 146.7 GB, 146695782400 bytes"

echo ${str:5:8}
