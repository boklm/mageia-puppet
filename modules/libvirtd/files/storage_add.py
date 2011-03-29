#!/usr/bin/python
import libvirt
import sys

name = sys.argv[1]
path = sys.argv[2]

storage_xml = """
<pool type='dir'>
  <name>%s</name>
  <capacity>0</capacity>
  <allocation>0</allocation>
  <available>0</available>
  <source>
  </source>
  <target>
    <path>%s</path>
    <permissions>
      <mode>0700</mode>
      <owner>-1</owner>
      <group>-1</group>
    </permissions>
  </target>
</pool>""" % ( name, path )

c=libvirt.open("qemu:///system")
c.storagePoolDefineXML(storage_xml,0)

