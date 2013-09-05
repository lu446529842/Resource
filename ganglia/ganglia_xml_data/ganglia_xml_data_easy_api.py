#!/usr/bin/env python
#
#provide easy API to get josn data
#

from get_xml_data_from_ganglia_server import parse_filter_summary

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



def test_api(json = None):
    """
    test filter summay api
    """
    #print "================GRID========================="
    #grids,sub_json = filter_summary_get_grids(json)
    #for grid in grids :
    #    print grid;
    #print "================cluster ========================="
    #clusters,sub_json = filter_summary_get_clusters(json)
    #for cluster in clusters :
	print cluster
    print "=================GRID METRIC============================"
    g_metrics ,sub_json=  filter_summary_get_grid_metric(json,"unspecified")
    for metric in g_metrics :
	print metric

    print "=================CLUSTER METRIC============================"
    c_metrics,sub_json = filter_summary_get_cluster_metric(json,"my_cluster")
    for metric in c_metrics :
	print metric
	print sub_json[metric]
	
  
   
    
if __name__ == "__main__" :
   filter_data = parse_filter_summary("127.0.0.1",8652,"/?filter=summary\n") 
   test_api(filter_data)
   
