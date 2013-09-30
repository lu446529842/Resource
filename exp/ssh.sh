#!/bin/sh

auto_mkdir () {
    expect -c "set timeout -1;
                spawn ssh  ${@:2};
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
 
auto_mkdir  "123"    "root@9.111.222.102:/root" "mkdir /root/demos"
echo $?
