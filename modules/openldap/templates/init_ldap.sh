#!/bin/bash

ldapadd -Y EXTERNAL -H ldapi:/// <<EOF
dn: <%= dc_suffix %>
dc: <%= dc_suffix.split(',')[0].split('=')[1] %>
objectClass: domain
objectClass: domainRelatedObject
associatedDomain: <%= domain %>

dn: ou=People,<%= dc_suffix %>
ou: People
objectClass: organizationalUnit

dn: ou=Group,<%= dc_suffix %>
ou: Group
objectClass: organizationalUnit

dn: cn=mga-packagers,ou=Group,<%= dc_suffix %>
objectClass: groupOfNames
objectClass: posixGroup
cn: mga-packagers
gidNumber: 5003
member: cn=manager,<%= dc_suffix %>

EOF
