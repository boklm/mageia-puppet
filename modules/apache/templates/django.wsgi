#!/usr/bin/python
import os, sys
<%- for m in module_path -%>
path = '<%= m %>'
if path not in sys.path:
    sys.path.append(path)
<%- end -%>

<%- if django_module -%>
os.environ['DJANGO_SETTINGS_MODULE'] = '<%= django_module %>.settings'
<%- else -%>
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
<%- end -%>

import django.core.handlers.wsgi

application = django.core.handlers.wsgi.WSGIHandler()

