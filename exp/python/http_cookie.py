#!/usr/bin/env python

import urllib2
import cookielib

#=====================================================
#function	get coobkie item
#=====================================================
def list_cookie(url = 'http://www.mop.com'):
    cookie = cookielib.CookieJar()
    print url
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cookie))
    response = urllib2.urlopen(url)
    for item in cookie:
        print item


list_cookie()

