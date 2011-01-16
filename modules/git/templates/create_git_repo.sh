#!/bin/bash
umask 0002
# http://eagleas.livejournal.com/18907.html
name="$1"
mkdir -p $name
cd $name 
git --bare init --shared=group 
chmod g+ws branches info objects refs 
( cd objects; chmod g+ws * )
