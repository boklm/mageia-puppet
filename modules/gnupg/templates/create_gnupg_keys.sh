#!/bin/bash

NAME=$1

/sbin/rngd -f -r /dev/urandom &
RAND=$!
cd /etc/gnupg/keys/
gpg --homedir /etc/gnupg/keys/ --batch --gen-key /etc/gnupg/batches/$NAME.batch 
EXIT=$?

kill $RAND

exit $EXIT
