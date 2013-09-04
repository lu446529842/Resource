#!/usr/bin/env	python
from  xml.dom import  minidom

def load_xml_data(path = ''):
    doc_tree = minidom.parse(path)
    root_element = doc_tree.documentElement
    Metrics = root_element.getElementsByTagName("METRIC")
    for metric in Metrics:
	items = metric.getElementsByTagName("EXTRA_DATA")
	print metric.getAttribute("NAME"),"-------------"
	for item in items:
	    extras = item.getElementsByTagName("EXTRA_ELEMENT")
	    for extra in extras:
		print extra.tagName
		print extra.getAttribute("NAME")
		print extra.getAttribute("VAL")
	    print "=================="
if __name__ == "__main__":
  load_xml_data("ganglia_metric") 
