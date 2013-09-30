import re
import subprocess


cmd = 'ping -c 1' + ' ' + '127.0.0.1'

result = subprocess.Popen(cmd,stdout = subprocess.PIPE,stdin = subprocess.PIPE,stderr = subprocess.PIPE,shell = True)
out_msg = result.stdout.read()
p = re.compile(r'\d+\.\d+\.\d+\.\d+')
msg = p.search(out_msg)

if msg:
   print msg.group()
else:
   print msg



str1 = 'asdfasdfkljlkasdfkjlasdf'

if 'asdf' in str1 :
   print str1
