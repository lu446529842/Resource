#!/usr/bin/env python

from  xml.dom import  minidom

def element_filter(elements = None):
    """
    element filter
    """
    if not elements :
	return
    element_list = []
    for element in elements :
	if element.nodeName != "#text" :
	   element_list.append(element)

    return element_list



def element_filter_by_string(elements = None,filter = ""):
    """
    element filter by string
    """
    if not elements :
        return
    element_list = []
    for element in elements:
        if element.nodeName == filter :
           element_list.append(element)

    return element_list


def get_metric(metric):
    """
    parse metric element to json data
    """
    M_NAME = metric.getAttribute("NAME")
    M_SUM = metric.getAttribute("SUM")
    M_TYPE = metric.getAttribute("TYPE")
    M_UNITS = metric.getAttribute("UNITS")
    M_SLOPE = metric.getAttribute("SLOPE")
    M_SOURCE = metric.getAttribute("SOURCE")
    temp = {}
    temp[M_NAME]= {}
    temp[M_NAME]["name"] = M_NAME
    temp[M_NAME]["sum"] = M_SUM
    temp[M_NAME]["type"] = M_TYPE
    temp[M_NAME]["units"] = M_UNITS
    temp[M_NAME]["slope"] = M_SLOPE
    temp[M_NAME]["source"] = M_SOURCE

    temp[M_NAME]["extra_data"] = {}
    EXTRA_DATA = metric.getElementsByTagName("EXTRA_DATA")[0]
    extra_elements = EXTRA_DATA.getElementsByTagName("EXTRA_ELEMENT")
    for extra_elememt in extra_elements :
        E_NAME = extra_elememt.getAttribute("NAME")
        E_VAL = extra_elememt.getAttribute("VAL")
        temp[M_NAME]["extra_data"][E_NAME]={}
        temp[M_NAME]["extra_data"]["name" ] = E_NAME
        temp[M_NAME]["extra_data"]["val" ] = E_VAL

    return temp,M_NAME
    

def get_host(host = None):
    """
    parse host att to json
    """
    if host == None :
       return

    temp = {}

    H_NAME = host.getAttribute("NAME")
    H_IP   = host.getAttribute("IP")
    H_REPORTED = host.getAttribute("REPORTED")
    H_TN = host.getAttribute("TN")
    H_TMAX = host.getAttribute("TMAX")
    H_DMAX = host.getAttribute("DMAX")
    H_LOCATION = host.getAttribute("LOCATION")
    H_GMOND_STARTED = host.getAttribute("GMOND_STARTED")
    temp[H_NAME] = {}
    temp[H_NAME]["name"] = H_NAME
    temp[H_NAME]["ip"] = H_IP
    temp[H_NAME]["reported"] = H_REPORTED
    temp[H_NAME]["tn"]  = H_TN
    temp[H_NAME]["tmax"]  = H_TMAX
    temp[H_NAME]["dmax"]  = H_DMAX
    temp[H_NAME]["localtion"]  = H_LOCATION
    temp[H_NAME]["gmond_started"]  = H_GMOND_STARTED

    return temp,H_NAME
   


def parse_cluster_xml(file = None):
    """
	get grid summary from specific xml data
    """
    if not file :
       print 'you have to specific xml data path' 
       return

    ganglia_data = {}
    
    doc = minidom.parseString(file)
    root = doc.documentElement
    R_NAME = root.nodeName
    R_VERSION = root.getAttribute("VERSION")
    SOURCE = root.getAttribute("SOURCE")
    
    ganglia_data["name"] = R_NAME
    ganglia_data["version"] = R_VERSION
    ganglia_data["source"] = SOURCE
    ganglia_data["grids"] = {}
    Grids = element_filter(root.childNodes)
    # root=>grids
    for grid in Grids :
	G_NAME = grid.getAttribute("NAME")
	G_AUTHORITY = grid.getAttribute("AUTHORITY")
	G_LOCALTIME = grid.getAttribute("LOCALTIME")
	ganglia_data["grids"][G_NAME]= {}
	ganglia_data["grids"][G_NAME]["name"] = G_NAME
	ganglia_data["grids"][G_NAME]["authority"] = G_AUTHORITY
	ganglia_data["grids"][G_NAME]["localtime"] = G_LOCALTIME

	ganglia_data["grids"][G_NAME]["clusters"] = {}

	clusters = element_filter(grid.childNodes)
	for cluster in clusters :
	    C_NAME = cluster.getAttribute("NAME")
            C_LOCALTIME = cluster.getAttribute("LOCALTIME")
            C_OWNER = cluster.getAttribute("OWNER")
            C_LATLONG = cluster.getAttribute("LATLONG")
            C_URL = cluster.getAttribute("URL")
            ganglia_data["grids"][G_NAME]["clusters"][C_NAME] = {}
            ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["name"] = C_NAME
            ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["localtime"] = C_LOCALTIME
            ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["owner"] = C_OWNER
            ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["latlong"] = C_LATLONG
            ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["url"] = C_URL
	
	    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"] = {}
	    hosts = element_filter(cluster.childNodes)
	    for host in hosts :
		host_dic ,name = get_host(host)
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"][name]=host_dic[name]
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"][name]["metrics"] = {}
		metrics = element_filter(host.childNodes)
		for metric in metrics :
		    metric_dic,m_name = get_metric(metric)
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"][name]["metrics"][m_name] = metric_dic[m_name]




    return ganglia_data

def get_key_in_dic(dic = None):
    """
    get dic  key
    """
    if dic == None :
       return

    keys = []

    for key in dic :
	keys.append(key)

    return keys


def print_dic(dic = None):
    """
    print dic
    """
    if not dic :
       return
    for key in dic :
        if "dic" in str(type(dic[key])):
	   print ""
	   print key
	   print_dic(dic[key])
        else :
	   print "%s:%s"% (key,dic[key])

    print '================================================='


if __name__ == "__main__":
  filter_data =  parse_filter_summary_xml("/root/mygit/ganglia_xml_data/xml_data/my_cluster_host")
  print filter_data


