#!/bin/bash
GIT_REP="$1"
LOCKFILE="$GIT_REP/.git/update.cron.lock"

cd "$GIT_REP"
[ -f $LOCKFILE ] && exit 0
trap "rm -f '$LOCKFILE'" EXIT 

touch "$LOCKFILE"

/usr/bin/git svn fetch 
/usr/bin/git svn rebase
exit 0
