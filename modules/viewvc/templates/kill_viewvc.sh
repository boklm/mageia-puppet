#!/bin/sh

max_memory=1000000

for process in `pgrep viewvc.fcgi`
do
    process_mem=$(pmap "$process" | grep total | sed 's/ \+total \+\([[:digit:]]\+\)K/\1/')
    if [ "$process_mem" -gt "$max_memory" ]
    then
	kill -15 "$process"
    fi
done

