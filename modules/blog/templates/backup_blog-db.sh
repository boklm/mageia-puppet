#!/bin/sh

# Initialization
PATH_TO_FILE=${PATH_TO_FILE:-/var/lib/blog/backup}
for locale in de el en es fr it nl pl pt ro ru tr
do
	/usb/bin/mysqldump --add-drop-table -h localhost blog_$locale | bzip2 -c > $PATH_TO_FILE/mageia_$locale.bak.sql.bz2
done
