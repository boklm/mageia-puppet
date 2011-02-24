#!/usr/bin/python
import sys
group_name = sys.argv[1]

from django.contrib.auth.models import Group
try:
    group = Group.objects.get(name=group_name)
except Group.DoesNotExist:
    group = Group.objects.create(name=group_name) 
    group.save()


