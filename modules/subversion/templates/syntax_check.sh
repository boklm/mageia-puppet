#!/bin/sh

REPOS="$1"
TXN="$2"

changed=`svnlook changed -t "$TXN" "$REPOS"`
files=`echo $changed | awk '{print $2}'`
if echo $files | grep <%= regexp_ext %>
then
   svnlook cat -t "$TXN" "$REPOS" "$files" | <%= check_cmd %>
   if [ $? -ne 0 ]
       then
       echo "Syntax error in $files." 1>&2
       echo "Check it with <%= check_cmd %>" 
       exit 1
   fi
fi

# All checks passed, so allow the commit.
exit 0

