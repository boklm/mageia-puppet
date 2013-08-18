#!/bin/sh

REP="$1"
TXN="$2"

author=$(svnlook author -t "$TXN" "$REP")

# This is here only the time we use hook_sendmail.pl
# We will be able to remove it when updating to a better send mail hook

if [ "$author" = 'schedbot' ]; then
  LIST=`ls -1 $0.d/* | grep -v send_mail`
else
  LIST=`ls -1 $0.d/*`
fi
 
for script in $LIST; do
    if [ ! -x "$script" ]; then
        continue
    fi

    if [[ "$script" == *~ ]]; then
        continue
    fi

    $script $@ || exit 1
done
