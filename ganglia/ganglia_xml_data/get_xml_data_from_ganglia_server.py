#!/usr/bin/env python
import socket
import select
import pickle
from cluster import parse_cluster_xml
from filter_summary import parse_filter_summary_xml
from my_cluster_filter_summary import parse_my_cluster_filter_summary_xml


def read_data_from_port(host = "127.0.0.1", port = 8651, send=None):
	"""
	fetch xml data from specific host and port with query string
	"""
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            sock.connect((host, port))
            r, w, x = select.select([sock], [], [], 2)
            if r:
                sock.close()
                return
        except socket.error, e:
	    print "Could not open socket to %s:%d - %s"% (host,port,e)
            return

        try:
            if send is not None: sock.send(send)
        except socket.error, e:
	    print "Could not send to %s:%d - %s"% (host,port,e)
            return

        buffer = ""
        while True:
            try:
                data = sock.recv(8192)
            except socket.error, e:
                logger.warning('Could not receive data from %s:%d - %s', host, port, e)
	        print "Could not receive data from  %s:%d - %s"% (host,port,e)
                return

            if not data: break
            buffer += data.decode("ISO-8859-1")

        sock.close()
        return buffer

def parse_filter_summary(host = "127.0.0.1", port = 8652, send= "/?filter=summary"):
    """
    fetch data from gmetad ,parse into json,request :/?filter=summary
    """
    xml_data = read_data_from_port(host,port,send)
    filter_json = parse_my_cluster_filter_summary_xml(xml_data)
    return filter_json

def parse_my_cluster(host = "127.0.0.1", port = 8652, send="/my_cluster\n"):
    """
    return /clusterName/hostName or /clusterName query data to json
    """
    xml_data = read_data_from_port(host,port,send)
    my_cluster_data = parse_cluster_xml(xml_data)
    return my_cluster_data


def parse_cluster_filter_summary(host = "127.0.0.1", port = 8652, send= "/my_cluster?filter=summary\n"):
    """
    return /clusterName?filter=summary  query data to json
    """
    xml_data = read_data_from_port(host,port,send) 
    my_cluster_filter_data = parse_my_cluster_filter_summary_xml(xml_data)
    return my_cluster_filter_data

def write_json_tofile(file = None,json = None):
    """
    use pickle data write data to specific  file path
    """
    json_file = open(file,"wb")
    pickle.dump(json,json_file)


if __name__ == "__main__":
   print parse_filter_summary("127.0.0.1",8652,"/?filter=summary\n")
   #print parse_my_cluster("127.0.0.1",8652,"/my_cluster\n")
   #json_data = parse_cluster_filter_summary("127.0.0.1",8652,"/my_cluster?filter=summary\n")
   #write_json_tofile("/root/cluster_filter_summary.json",json_data)

