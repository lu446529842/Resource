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


def parse_my_cluster_filter_summary_xml(file = None):
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

	g_elements = element_filter(grid.childNodes)
	for sub_g  in g_elements :
	    G_cluster = element_filter_by_string(g_elements,"CLUSTER")

	    #root=>grids=>grid=>clusters
	    ganglia_data["grids"][G_NAME]["clusters"] = {}
	    for cluster in G_cluster:
		C_NAME = cluster.getAttribute("NAME")
		C_LOCALTIME = cluster.getAttribute("LOCALTIME")
		C_OWNER = cluster.getAttribute("OWNER")
		C_LATLONG = cluster.getAttribute("LATLONG")
		C_URL = cluster.getAttribute("URL")
		#root=>grids=>grid=>clusters=>cluster
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME] = {}
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["name"] = C_NAME
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["localtime"] = C_LOCALTIME
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["owner"] = C_OWNER
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["latlong"] = C_LATLONG
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["url"] = C_URL

		sub_c = element_filter(cluster.childNodes)
		c_hosts = element_filter_by_string(sub_c,"HOSTS")
		c_metric = element_filter_by_string(sub_c,"METRICS")
		#root=>grids=>grid=>clusters=>cluster=>hosts
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"] = {}
		for hosts in c_hosts :
		    C_UP = hosts.getAttribute("UP")
                    C_DOWN = hosts.getAttribute("DOWN")
                    C_SOURCE = hosts.getAttribute("SOURCE")
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"]["up"] = C_UP
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"]["source"] = C_SOURCE
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["hosts"]["down"] = C_DOWN
		#root=>grids=>grid=>clusters=>cluster=>metrics
		ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"] = {}
		for metric in c_metric :
		    M_NAME = metric.getAttribute("NAME")
                    M_SUM = metric.getAttribute("SUM")
                    M_TYPE = metric.getAttribute("TYPE")
                    M_UNITS = metric.getAttribute("UNITS")
                    M_SLOPE = metric.getAttribute("SLOPE")
                    M_SOURCE = metric.getAttribute("SOURCE")
		    #root=>grids=>grid=>clusters=>cluster=>metrics=>metric
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME] = {}
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["name"] = M_NAME
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["sum"] = M_SUM
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["type"] = M_TYPE
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["units"] = M_UNITS
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["slope"] = M_SLOPE 
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["source"] =  M_SOURCE

		    #root=>grids=>grid=>clusters=>cluster=>metrics=>metric=>extra_data
		    ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["extra_data"] = {}
		    EXTRA_DATA = metric.getElementsByTagName("EXTRA_DATA")[0]
                    extra_elements = EXTRA_DATA.getElementsByTagName("EXTRA_ELEMENT")
                    for extra_elememt in extra_elements :
		    #root=>grids=>grid=>clusters=>cluster=>metrics=>metric=>extra_data=>EXTRA_ELEMENT
                        E_NAME = extra_elememt.getAttribute("NAME")
                        E_VAL = extra_elememt.getAttribute("VAL")
			ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["extra_data"][E_NAME]={}
			ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["extra_data"][E_NAME]["name"] = E_NAME
			ganglia_data["grids"][G_NAME]["clusters"][C_NAME]["metrics"][M_NAME]["extra_data"][E_NAME]["val"] = E_VAL




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
  filter_data =  parse_filter_summary_xml("/root/mygit/ganglia_xml_data/xml_data/my_cluster_filter_summary")
  print filter_data


