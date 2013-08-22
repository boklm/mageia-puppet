#!/bin/sh

REV=$1
if [ -z "$1" ]; then
	echo "Unknown Commit"
	exit
fi
if [ -z "$GL_REPO" ]; then
	echo "Cannot find Gitolite Repository"
	exit
fi

echo '-----------------------------------------------------------------------'
echo
echo "http://gitweb.mageia.org/$GL_REPO/commit/?id=$REV"
echo
echo
git show -C $REV
echo
