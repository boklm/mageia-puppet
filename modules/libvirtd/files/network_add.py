#!/usr/bin/python
import libvirt
import os
import IPy

# bridge_name 

# forward -> nat/ route
# forward-dev

# network 
# => deduire la gateway , et le range
# en dhcp automatiquement

# tftp_root

# enable_pxelinux


bridge_name = os.environ.get('BRIDGE_NAME', 'virbr0')
forward = os.environ.get('FORWARD', 'nat')
forward_dev = os.environ.get('FORWARD_DEV', 'eth0')

network = os.environ.get('NETWORK', '192.168.122.0/24')

tftp_root = os.environ.get('TFTP_ROOT', '')
disable_pxelinux = os.environ.get('DISABLE_PXE', False)

name = os.environ.get('NAME', 'default')


ip = IPy.IP(network)
gateway = ip[1]
dhcp_start = ip[2]
dhcp_end = ip[-2]

netmask = ip.netmask()
tftp_xml = ''
pxe_xml = ''

if tftp_root:
    tftp_xml = "<tftp root='" + tftp_root + "' />"
    if not disable_pxelinux:
            pxe_xml = "<bootp file='pxelinux.0' />"

network_xml = """
<network>
        <name>%(name)s</name>
        <bridge name="%(bridge_name)s" />
        <forward mode="%(forward)s" dev="%(forward_dev)s"/>
        <ip address="%(gateway)s" netmask="%(netmask)s">
          %(tftp_xml)s
          <dhcp>
            <range start="%(dhcp_start)s" end="%(dhcp_end)s" />
            %(pxe_xml)s
          </dhcp>
        </ip>
</network>""" % globals()

c=libvirt.open("qemu:///system")
c.networkDefineXML(network_xml)

