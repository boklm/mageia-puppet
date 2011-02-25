#!/usr/bin/python
import sys
group_name = sys.argv[1]
permission = sys.argv[2]

# as codename is not unique, we need to give the application name
app = ''
if len(sys.argv) > 3:
        app = sys.argv[3]

from django.contrib.auth.models import Group, Permission
group = Group.objects.get(name=group_name)

permissions = Permission.objects.filter(codename=permission)
if app:
    permissions = permissions.filter(content_type__app_label__exact=app)

if len(permissions) > 1:
	print "Error, result not unique, please give the application among :"
	print ' '.join([p.content_type.app_label for p in permissions])
	sys.exit(1)
elif len(permissions) < 1:
	print "Error, wrong codename"
	sys.exit(1)

group.permissions.add(permissions[0])
group.save()
