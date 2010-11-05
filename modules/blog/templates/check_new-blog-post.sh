#!/bin/sh

# Initialization
PATH_TO_FILE="/home/blog"
/usr/bin/wget -qO $PATH_TO_FILE"/RSS_new" http://blog.mageia.org/?feed=rss2
/bin/date +"%d:%m:%Y %H:%M" > $PATH_TO_FILE"/last_check"

# Check if RSS_old exists
if [ ! -f $PATH_TO_FILE"/RSS_old" ]
	then
		/bin/cp $PATH_TO_FILE"/RSS_new" $PATH_TO_FILE"/RSS_old"
		/bin/rm -rf $PATH_TO_FILE"/RSS_new" $PATH_TO_FILE"/last_check"
		exit 1
fi

# Check if a new blog post on EN needs to be translated on other blogs
tmp_new=$(/bin/grep 'lastBuildDate' $PATH_TO_FILE"/RSS_new")
tmp_old=$(/bin/grep 'lastBuildDate' $PATH_TO_FILE"/RSS_old")
if [ "$tmp_old" = "$tmp_new" ]
	then
		# Nothing new
		echo "NO" >> $PATH_TO_FILE"/last_check"
	else
		# New post to translate
		echo "YES" >> $PATH_TO_FILE"/last_check"
		echo "blablabla" /bin/mail -s "New entry on English Blog to translate" damien@damsweb.net
		echo $DATE
fi

# Clean tmp files and copy RSS_new to RSS_old
/bin/cp $PATH_TO_FILE"/RSS_new" $PATH_TO_FILE"/RSS_old"
/bin/rm -rf $PATH_TO_FILE"/RSS_new"
