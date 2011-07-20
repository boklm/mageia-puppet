#!/usr/bin/perl -MSVN::Notify::Config=$0
--- #YAML:1.0

'':
  PATH: "/usr/bin:/usr/local/bin"
  handler: Alternative
  alternative: HTML::ColorDiff
  with-diff: 1
  max_diff_length: 20000
  from: root@<%= domain %>
  to:
<%- commit_mail.each do |mail|  -%>
    - <%= mail %>
<%- end -%>
<%- if i18n_mail != '' -%>
'.*\.pot$':
  PATH: "/usr/bin:/usr/local/bin"
  handler: Alternative
  alternative: HTML::ColorDiff
  with-diff: 1
  max_diff_length: 20000
  from: root@<%= domain %>
  to: <%= i18n_mail %>
<%- end -%>
