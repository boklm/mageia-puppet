#!/usr/bin/perl -MSVN::Notify::Config=$0
--- #YAML:1.0

'':
  PATH: "/usr/bin:/usr/local/bin"
  handler: Alternative
  alternative: HTML::ColorDiff
  with-diff: 1
  to:
<%- commit_mail.each do |mail|  -%>
    - <%= mail %>
<%- end -%>
  from: root@<%= domain %>
