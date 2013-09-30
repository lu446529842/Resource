#/usr/bin/env python

import os
import sys

def findAllCombine(n = 0, m = 0,list = None):
	"""
	"""
	if n <= 0 or m <= 0 :
		return

	if n == m :
		list.append(n)
		for num in list:
			print num
		print "==========================="
		list.pop()

	if n > m :
		n = m
		findAllCombine(n,m,list)
	
	list.append(n)
	findAllCombine(n-1,m-n,list)
	list.pop()
	findAllCombine(n-1,m,list)



if __name__ == "__main__" :
	list = []
	findAllCombine(10,10,list)
