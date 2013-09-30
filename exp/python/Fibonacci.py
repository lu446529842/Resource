#*************************************************************************
#	> File Name: Fibonacci.py
#	> Author: ldq
#	> Mail: 446529842@qq.com 
# ************************************************************************/
#/usr/bin/python
import os


def Fibonacci(n):
	"""
	"""

	if n == 0:
		return 0;
	if n == 1 :
		return 1

	return Fibonacci(n-1)+Fibonacci(n-2)



if __name__ ==  "__main__":
	print Fibonacci(10)
