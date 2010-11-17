#!/usr/bin/python
import os, sys
sys.path.append('<%= module_path  %>')
os.environ['DJANGO_SETTINGS_MODULE'] = '<%= module %>.settings'

import django.core.handlers.wsgi

application = django.core.handlers.wsgi.WSGIHandler()

