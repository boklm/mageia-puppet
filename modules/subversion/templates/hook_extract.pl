#!/usr/bin/perl -MSVN::Notify::Config=$0
--- #YAML:1.0
<%- extract_dir.each do |src,dest| -%>
'<%= src %>':
  PATH: "/usr/bin:/usr/local/bin"
  handler: Mirror
  svn-binary: /usr/bin/svn
  to: <%= dest %>
<%- end -%>
