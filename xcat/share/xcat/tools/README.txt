xCAT TOOL DESCRIPTIONS
----------------------

This is a list of additional tools that are provided by xCAT.  They are located
in /opt/xcat/share/xcat/tools/, but should also be in your path.  Many of these
tools have been contributed by xCAT users that are not part of the core xCAT
development team.  That means they might not be supported as well as the main
xCAT code.  Read the help here, take a look at the code, and use at your own
risk.  If you have problems with a tool, post to the xCAT mailing list and
the author will try to help you.


cronEdit
--------------------

Usage: cronEdit <-a | -d> <cron file>

Error: execution of './share/xcat/tools/cronEdit --help' failed with rc=1.


detect_dhcpd
--------------------

Usage: detect_dhcpd -i interface [-m macaddress] [-t timeout] [-V]

This command can be used to detect the dhcp server in a network for a specific mac address.

Options:
    -i interface:  The interface which facing the target network.
    -m macaddress: The mac that will be used to detect dhcp server. Recommend to use the real mac of the node that will be netboot. If no specified, the mac of interface which specified by -i will be used.
    -t timeout:    The time to wait to detect the dhcp messages. The default value is 10s.

Author:  Wang, Xiao Peng


mac2linklocal
--------------------

Usage:  mac2linklocal -m <mac_address>

Determines the IPv6 link local address that is appropriate for a NIC, based on its MAC.

Author:  Li, Guang Cheng


mktoolscenter
--------------------

Usage: mktoolscenter
  --ph <proxyhost>
  --pp <proxyport>
  --puser <proxyuser>
  --ppw <proxypassword>
  -l <logfile>
  -s
  --nfsserver <NFS server address>
  --nfspath <NFS server path>
  --profilename <profile name>
  --help

Updates IBM system x server hardware using IBM Bootable Media Creator.

Author:  Jim Turner


nodesw
--------------------

nodesw changes the vlan of a node to a specified vlan
requires xCAT 2.0, Switch configured with SNMP sets, and only tested on SMC8648T
nodesw -h|--help
nodesw [-v] <noderange> vlan <vlan number>
nodesw [-v] <noderange> show

Author:  Vallard Benincosa


reorgtbls
--------------------

DB2 Table Reorganization utility.
This script can be set as a cron job or run on the command line to reorg the xcatdb DB2 database tables. It automatically added as a cron job, if you use the db2sqlsetup command to create your DB2 database setup for xCAT. 
Usage:
	--V - Verbose mode
	--h - usage
	--t -comma delimitated list of tables.
             Without this flag it reorgs all tables in the xcatdb database .

Author:  Lissa Valletta


rmblade
--------------------

Usage: rmblade [-h|--help]

Response to SNMP for monsetting to remove blade from xCAT when trap is recieved.
Pipe the MM IP address and blade slot number into this cmd.

Example: 
 1.  user removes a blade from the chassis
 2.  snmp trap setup to point here
 3.  this script removes the blade configuration from xCAT
 4.  so if blade is placed in new slot or back in then xCAT goes 
     through rediscover process again.

Author:  Jarrod Johnson


rmnodecfg
--------------------

Usage: rmnodecfg [-h|--help] <noderange>

Removes the configuration of a node so that the next time you reboot 
it, it forces it to go through the discovery process.
This does not remove it completely from xCAT.  You may want to do this
command before running noderm to completely purge the system of the node

Author:  Vallard Benincosa


test_hca_state
--------------------

test_hca_state (part of the BEF_Scripts for xCAT) v3.2.27

Usage: test_hca_state NODERANGE | xcoll

    --help  Display this help output.

Purpose:  

    This tool provides a quick and easily repeatable method of
    validating key InfiniBand adapter (HCA) and node based InfiniBand
    settings across an entire cluster.  
    
    Having consistent OFED settings, and even HCA firmware, can be very
    important for a properly functioning InfiniBand fabric.  This tool
    can help you confirm that your nodes are using the settings you
    want, and if any nodes have settings descrepancies.


Example output:

    In the output below, note the following discrepancies for the node
    storage1 (as compared with all of the other nodes): "rate",
    "PortRcvErrors", and "IB HCA FW Active".  Looks like that guy may
    need a restart of the OFED stack to engage his newly installed
    firmware. ;-)

    [root]# test_hca_state compute,storage | xcoll
    ====================================
    storage1
    ====================================
    OFED: MLNX_OFED_LINUX-1.5.3-4.0.22.3 (OFED-1.5.3-4.0.22):
    mlx4_0/1:
     phys state:     5: LinkUp
     rate:       40 Gb/sec (4X FDR10)
    PCI: Gen3
    SymbolErrorCounter: 0
    PortRcvErrors: 31
    IB HCA FW Installed: 2.11.500
    IB HCA FW Active:    2.10.2372
    mlx4_core set_4k_mtu: 0
    mlx4_core log_num_mtt: 20
    mlx4_core log_mtts_per_seg: 7
    IPoIB Mode: connected
    IPoIB MTU:  65520
    IPoIB recv_queue_size: 8192
    IPoIB send_queue_size: 8192
    
    ====================================
    compute,storage2,storage3,storage4
    ====================================
    OFED: MLNX_OFED_LINUX-1.5.3-4.0.22.3 (OFED-1.5.3-4.0.22):
    mlx4_0/1:
     phys state:     5: LinkUp
     rate:       56 Gb/sec (4X FDR)
    PCI: Gen3
    SymbolErrorCounter: 0
    PortRcvErrors: 0
    IB HCA FW Installed: 2.11.500
    IB HCA FW Active:    2.11.500
    mlx4_core set_4k_mtu: 0
    mlx4_core log_num_mtt: 20
    mlx4_core log_mtts_per_seg: 7
    IPoIB Mode: connected
    IPoIB MTU:  65520
    IPoIB recv_queue_size: 8192
    IPoIB send_queue_size: 8192

Author:  Brian Finley
