#!/bin/bash
umask 0002
# needed for http://idolinux.blogspot.com/2010/05/subversion-svn-group-permissions.html
svnadmin create --pre-1.6-compatible "$1"
#chmod g+w "$1"/db/txn-current-lock
#chmod g+w "$1"/db/transactions
#chmod g+w "$1"/db/locks
