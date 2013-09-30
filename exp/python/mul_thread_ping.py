#!/usr/bin/env python 
import subprocess
import thread
import time
import re


#=====================================================
#function	show out put msg
#=====================================================
def show_out_msg(msg = '' ,type = 'out_msg'):
    if type == 'out_msg':
       p = re.compile(r'\d+\.\d+\.\d+\.\d+')
       result = p.search(msg)  
       host_address = result.group()

       if 'icmp_seq' in msg :
          alive = host_address + '  is alive'
	  print alive
       else:
          dead = host_address + '  unreachable' 
	  print dead
    else:
	print '=========================================================='
	print '= network or host_address error ,pls check you error msg ='
	print '=========================================================='
        print ''
	print msg


#=====================================================
#function ping host , check it alive
#=====================================================
def check_host(host_address = '127.0.0.1',no = 'none'):
    cmd = 'ping -c 1' + ' ' + host_address
    
    result = subprocess.Popen(cmd,stdout = subprocess.PIPE,stdin = subprocess.PIPE,stderr = subprocess.PIPE,shell = True)
    out_msg = result.stdout.read()
    
    type = ''
    if not  out_msg:
       out_err = result.stderr.read()
       type = 'out_err'
    else:
       type = 'out_msg'


    if type == 'out_msg':
       p = re.compile(r'\d+\.\d+\.\d+\.\d+')
       result = p.search(out_msg)
       host_address = result.group()

       if 'icmp_seq' in out_msg :
          print host_address,'is alive'
       else:
          print host_address ,'unreachable'
    else:
        print '=========================================================='
        print '= network or host_address error ,pls check you error msg ='
        print '=========================================================='
        print ''
        print out_msg


#=============================================================
#function	mulThread ping 
#=============================================================
def multi_thread_check_host(prefix = '192.168.1.'):
    for item in range(1,254):
	ip_address = prefix + str(item)
        param = (ip_address,'')
        thread.start_new_thread(check_host,param)
    
    time.sleep(100)
#=============================================================
#function main
#=============================================================
if __name__ == '__main__':
   multi_thread_check_host('9.123.124.')
