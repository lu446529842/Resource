#!/usr/bin/env python
import os
import re
import sys
import threading
import time
import subprocess


host_resource_lock = threading.RLock()
resource = []
index  = 0
ranges = 0
alive_host = 0


class pinger(threading.Thread):
      def __init__(self,host_ip = '127.0.0.1',num = 0,prefix = '127.0.0.'):
	  threading.Thread.__init__(self)
	  self.host_ip = host_ip
	  self.num = num
	  self.prefix = prefix

      def show_msg(self,msg = '' ,type = 'out_msg'):
          if type == 'out_msg':
             p = re.compile(r'\d+\.\d+\.\d+\.\d+')
             result = p.search(msg)
             host_address = result.group()

             if 'icmp_seq' in msg :
                alive = host_address + '  is alive' + ', by thread : %d'% (self.num)
                print alive
		global alive_host
		alive_host += 1
             else:
                dead = '== '+host_address + '  unreachable'+ ', by thread : %d =='% (self.num)
                print dead
          else:
             print '=========================================================='
             print '= network or host_address error ,pls check you error msg ='
	     print '===============by thread :%d =========================='% (self.num)
             print '=========================================================='
             print ''
             print msg


      def run(self):
	  while True :
		host_resource_lock.acquire()
	        temp = get_resource()
		if temp == -1:
		   host_resource_lock.release()
		   self.thread_stop = True 
		   break
		host_resource_lock.release()
		self.host_ip = self.prefix + str(temp)
		
   	        cmd = 'ping -c 1' + ' ' + self.host_ip
	        result = subprocess.Popen(cmd,stdout = subprocess.PIPE,stderr = subprocess.PIPE,shell = True)
	        #result = subprocess.Popen(cmd,stdout = subprocess.PIPE,stdin = subprocess.PIPE,stderr = subprocess.PIPE,shell = True)
                out_msg = result.stdout.read()
	  	host_resource_lock.acquire()
 	        if out_msg :
	           self.show_msg(out_msg ,'out_msg')
	        else :
	           err_msg = result.stderr.read()
	           self.show_msg(err_msg ,'out_err')
		host_resource_lock.release()

def product_resource(start = 1,end = 254):
    """
    product host ip  ressource 
    """
    global ranges 
    global index
    global resource

    ranges = end - start
    index = 0
    resource = range(start,end)
   
def get_resource():
    """
    reurn the host resource if there is avalible
    """

    global ranges
    global index
    global resource

    if index < ranges:
       temp = resource[index]
       index = index + 1
       return temp
    return -1


def check_host_list(thread_size = 10,prefix = '9.123.124.',start = 1 ,end = 254) :
    """
    create thread to check hosts
    """
    product_resource(start,end)
   
    thread_list = []
    for item in range(1,thread_size) :
	host_ip = prefix + str(item)
	ping = pinger(host_ip,item,prefix)
	ping.start()
	thread_list.append(ping)

    for thread in thread_list:
	thread.join()	

def uage():
    print '================================================='
    print '========  input params ERRORR !!!! =============='
    print '================  UAGE  ========================='
    print ''
    print '=python script  thread_count ip_prefix start end='
    print '==== example  ./xxx.py  10 9.123.124. 1 254 ====='
    print ''
    print '==============  enjoy it ========================'



if __name__ == '__main__' :
   if len(sys.argv) == 5 :
       check_host_list(int(sys.argv[1]),sys.argv[2],int(sys.argv[3]),int(sys.argv[4]))
       
       global alive_host
       global ranges
       print ''
       print '======================================'
       print '======= check host statistic ========='
       print '====== there are %d hosts alive ==== '% (alive_host)
       print '====== there are %d hosts dead  ====='% (ranges  -alive_host)
       print '======================================'
   else :
 	uage()
