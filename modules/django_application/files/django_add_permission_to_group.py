#!/usr/bin/python
import sys
group_name = sys.argv[1]
permission = sys.argv[2]

# as codename is not unique, we need to give the application name
app = ''
if len(sys.argv) > 3:
        app = sys.argv[3]

from django.contrib.auth.models import Group, Permission
g = Group.objects.get(name=group_name)

p = Permission.objects.filter(codename=permission)
if app:
    p = p.filter(content_type__app_label__exact=app)
p = p[0]

g.permissions.add(p)
g.save()
