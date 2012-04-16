#!/bin/sh

# Initialization
PATH_TO_FILE=${PATH_TO_FILE:-<%= blog_files_backupdir %>}
[ ! -f $PATH_TO_FILE/count ] && echo 0 > $PATH_TO_FILE/count
COUNT=$(cat "$PATH_TO_FILE/count")
# Backup each locale
for locale in de el en es fr it nl pl pt ro ru tr uk
do
	if [ ! -d $PATH_TO_FILE/$locale ]
	then
		/bin/mkdir $PATH_TO_FILE/$locale
	fi
	tar Jcf $PATH_TO_FILE/$locale/$locale-$COUNT.tar.xz <%= blog_location %>/$locale
done
# Check count file to have a week of backup in the directory
if [ $COUNT -ne 6 ]
then
	COUNT=$(expr $COUNT + 1)
else
	COUNT="0"
fi
echo $COUNT > $PATH_TO_FILE/count
