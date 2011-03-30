#!/bin/sh

# Initialization
PATH_TO_FILE=${PATH_TO_FILE:-/var/lib/blog/backup}
[ ! -f $PATH_TO_FILE/count ] && echo 0 > $PATH_TO_FILE/count
COUNT=$(cat "$PATH_TO_FILE/count")
# Backup each locale DB
for locale in de el en es fr it nl pl pt ro ru tr
do
	if [ ! -d $PATH_TO_FILE/$locale ]
	then
		/bin/mkdir $PATH_TO_FILE/$locale
	fi
	rsync -avHP --delete /var/www/html/blog.mageia.org/$locale $PATH_TO_FILE/$locale/$locale-$COUNT
done
# Check count file to have a week of backup in the directory
if [ $COUNT -ne 6 ]
then
	COUNT=$(expr $COUNT + 1)
else
	COUNT="0"
fi
echo $COUNT > $PATH_TO_FILE/count
