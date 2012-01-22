#!/bin/bash

ldapadd -Y EXTERNAL -H ldapi:/// <<EOF
dn: <%= dc_suffix %>
dc: <%= dc_suffix.split(',')[0].split('=')[1] %>
objectClass: domain
objectClass: domainRelatedObject
associatedDomain: <%= domain %>

<% for g in ['People','Group'] %>
dn: ou=<%= g%>,<%= dc_suffix %>
ou: <%= g %>
objectClass: organizationalUnit
<% end %>

<%
gid = 5000
for g in ['packagers','web','sysadmin'] %>
dn: cn=mga-<% g %>,ou=Group,<%= dc_suffix %>
objectClass: groupOfNames
objectClass: posixGroup
cn: mga-<% g %>
gidNumber: <%= gid %>
member: cn=manager,<%= dc_suffix %>
<%-
gid+=1 
end -%>

EOF
