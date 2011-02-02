#!/bin/bash

BATCHFILE="$1"
HOMEDIR="$2"
LOCK="$3"

test $# -eq 3 || exit 1

if [ -e "$LOCK" ]
then
    echo "Lock file already exist." 1>&2
    echo "Remove $LOCK if you want to regenerate key." 1>&2
    exit 2
fi

touch "$LOCK"

/sbin/rngd -f -r /dev/urandom &
RAND=$!
cd $HOMEDIR
gpg --homedir $HOMEDIR --batch --gen-key $BATCHFILE
EXIT=$?

kill $RAND

exit $EXIT
