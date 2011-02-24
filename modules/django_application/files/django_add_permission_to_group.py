#!/usr/bin/python
import sys
group_name = sys.argv[1]
permission = sys.argv[2]

from django.contrib.auth.models import Group,Permission
g = Group.objects.get(name=group_name)
p = Permission.objects.get(codename=permission)

g.permissions.add(p)
g.save()
