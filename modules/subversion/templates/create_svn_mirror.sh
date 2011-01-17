#!/bin/bash
umask 0002
LOCAL_REPOS=$1
REMOTE_REPOS=$2
svnadmin create $LOCAL_REPOS
# needed, as svnsync complain otherwise :
#  svnsync: Repository has not been enabled to accept revision propchanges;
#  ask the administrator to create a pre-revprop-change hook
ln -s /bin/true $LOCAL_REPOS/hooks/pre-revprop-change  
svnsync init  file://$1  $2
# do not sync now,
# let cron do it or puppet will complain ( especially for long sync )
#svnsync synchronize file://$1
