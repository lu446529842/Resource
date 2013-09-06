#!/usr/bin/env python
#
#provide easy API to get josn data
#

from get_xml_data_from_ganglia_server import parse_filter_summary
from get_xml_data_from_ganglia_server import parse_cluster_filter_summary 
from get_xml_data_from_ganglia_server import parse_my_cluster 

#==================================================================
#util	get dic key
#===================================================================
def get_json_keys(json = None,keyName = None):
    """
    return specific key for json
    """

    if not json or not keyName :
       return
    keys = []
    tempJson = {}
    for key in json :
        if "dic" in str(type(json[key])) :
	   if keyName == key :
	      for _key in json[key]:
	          keys.append(_key)
	      return keys,json[key]
 	   else:
	      keys,tempJson =  get_json_keys(json[key],keyName)

    return keys,tempJson



#===================================================================
#util	get sub  json
#===================================================================
def get_sub_json(json = None,keyName = None):
    """
    get sub json in origin json
    """

    if not json or not keyName:
       return
    for key in json :
	if key == keyName and "dic" in str(type(json[key])):
	   return json[key]
	if "dic" in str(type(json[key])):
	   return get_sub_json(json[key],keyName)

    return 

#===================================================================
#AREA	FILTER SUMMARY
#===================================================================
def filter_summary_get_grids(json = None):
    """
    describles:json data from filter_summary
    pupose:get all grids 
    """
    return get_json_keys(json,"grids")



#===================================================================
#AREA	FILTER	SUMMARY
#===================================================================
def filter_summary_get_clusters(json = None):
    """
    return filter_summary clusters
    """
    return get_json_keys(json,"clusters")

#===================================================================
#AREA   FILTER  SUMMARY
#===================================================================
def filter_summary_get_grid_metric(json = None,grid = None):
    """
    return filter_summary grid metric
    """
    sub_json = get_sub_json(json,grid)
    return get_json_keys(sub_json,"metrics")

#===================================================================
#AREA	FILTER SUMMARY
#===================================================================
def filter_summary_get_cluster_metric(json = None,cluster = None):
    """
	return file_summary grid metric
    """
    sub_json = get_sub_json(json,cluster)
    metrics,temp_json = get_json_keys(sub_json,"metrics")
    return metrics,temp_json



#===================================================================
#AREA	FILTER	SUMMARY
#===================================================================
def filter_summary_cluster_get_girds(json =None):
    """
    """
    grids,sub_json = get_json_keys(json,"grids")
    return grids,sub_json

def filter_summary_cluster_get_hosts(json= None):
    """
    """
    hosts,sub_json = get_json_keys(json,"hosts")
    return hosts,sub_json

def filter_summary_filter_get_metrics(json = None):
    """
    """
    metrics ,sub_json = get_json_keys(json,"metrics")
    return metrics ,sub_json



def cluster_get_grids(json = None):
    grids ,sub_json = get_json_keys(json,"grids")
    return grids ,sub_json
    
def cluster_get_cluster(json = None):
    clusters,sub_json = get_json_keys(json,"clusters")
    return clusters,sub_json

def cluster_get_hosts(json = None,clusterName = None):
    sub_json = get_sub_json(json,clusterName)
    hosts ,sub_json = get_json_keys(sub_json,"hosts")
    return hosts ,sub_json

def cluster_get_host(json = None,hostName =None):
     host,metrics = get_json_keys(json,hostName)
     return host,metrics
def cluster_get_host_metrics(json):
    keys = []

    for key in json["metrics"]:
	keys.append(key)

    return keys,json["metrics"]


def cluster_test_api(json):
    grids,sub_json = cluster_get_grids(json)
    print grids

    clusters,sub_json = cluster_get_cluster(json)
    print clusters


    cluster = clusters[0]
    hosts,sub_json =  cluster_get_hosts(json,cluster)
    print hosts

    hostname = hosts[0]
    host,sub_json = cluster_get_host(sub_json,hostname)
    for att in host :
        print att, sub_json[att]

    metrics,sub_json = cluster_get_host_metrics(sub_json)
    print metrics
    
def filter_summary_cluster_test_api(json = None):
    grids ,sub_json = filter_summary_cluster_get_girds(json)
    print grids

    hosts,sub_json = filter_summary_cluster_get_hosts(json)
    print hosts

    metrics ,sub_json = filter_summary_filter_get_metrics(json)
    for metric in metrics :
        print metric,sub_json[metric]
    
def filter_summary_test_api(json = None):
    """
    test filter summay api
    """
    grids,sub_json = filter_summary_get_grids(json)
    for grid in grids :
        print grid;
    
    clusters,sub_json = filter_summary_get_clusters(json)
    for cluster in clusters :
	print cluster
    g_metrics ,sub_json=  filter_summary_get_grid_metric(json,"unspecified")
    for metric in g_metrics :
	print sub_json[metric]
	break

    c_metrics,sub_json = filter_summary_get_cluster_metric(json,"my_cluster")
    for metric in c_metrics :
	print metric
	print sub_json[metric]
	break
	
  
   
    
if __name__ == "__main__" :
   filter_data = parse_my_cluster("127.0.0.1",8652,"/my_cluster/9.123.124.203\n")
   cluster_test_api(filter_data)
 
   
