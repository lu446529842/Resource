#!/usr/bin/env	python
from  xml.dom import  minidom

def load_xml_data(path = ''):
    doc_tree = minidom.parse(path)
    root_element = doc_tree.documentElement
    grids = root_element.childNodes
    for grid in grids:
        for cluster in grid.childNodes:
	    for host in cluster.childNodes:
		for metric in host.childNodes:
		    print metric.nodeName

if __name__ == "__main__":
  load_xml_data("ganglia_metric") 
