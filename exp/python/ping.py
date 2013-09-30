#!/usr/bin/env python 
import subprocess


#=====================================================
#function	show out put msg
#=====================================================
def show_out_msg(msg = '' ,type = 'out_msg'):
       print '#=================================================='
       print '#=========================%s======================='% (type)
       print msg
       print '#=================================================='
       print ''

#=====================================================
#function ping host , check it alive
#=====================================================
def check_host(host_address = '127.0.0.1'):
    cmd = 'ping -c 4' + ' ' + host_address
    
    result = subprocess.Popen(cmd,stdout = subprocess.PIPE,stdin = subprocess.PIPE,stderr = subprocess.PIPE,shell = True)
    out_msg = result.stdout.read()
    
    if not out_msg:
       out_err = result.stderr.read()
       show_out_msg(out_err,'out_msg')
    else:
       show_out_msg(out_msg,'out_msg')


check_host()
check_host('9.123.24.203')
check_host('www.baidu.com')
