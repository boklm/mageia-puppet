#!/bin/sh

# Initialization
PATH_TO_FILE=${PATH_TO_FILE:-/var/lib/blog}
/usr/bin/wget -qO $PATH_TO_FILE"/RSS_new" http://blog.mageia.org/?feed=rss2
if [ -n $? ] 
then
        exit 2
fi
# Check if RSS_old exists
if [ ! -f $PATH_TO_FILE"/RSS_old" ]
	then
		/bin/mv -f $PATH_TO_FILE"/RSS_new" $PATH_TO_FILE"/RSS_old"
		exit 1
fi

/bin/date +"%d:%m:%Y %H:%M" > $PATH_TO_FILE"/last_check"

# Check if a new blog post on EN needs to be translated on other blogs
tmp_new=$(/bin/grep 'lastBuildDate' $PATH_TO_FILE"/RSS_new")
tmp_old=$(/bin/grep 'lastBuildDate' $PATH_TO_FILE"/RSS_old")
if [ "$tmp_old" = "$tmp_new" ]
	then
		# Nothing new
		echo "NO" >> $PATH_TO_FILE"/last_check"
	else
		# New post to translate
		cat $PATH_TO_FILE"/last_check" > $PATH_TO_FILE"/last_need_translation"
		new_post=$(grep "title" $PATH_TO_FILE"/RSS_new" | head -n 2 | sed '1d' | sed 's/<title>//' | sed 's/<\/title>//' | sed 's/^[ \t]*//')
		echo $new_post >> $PATH_TO_FILE"/last_need_translation"
		echo "YES" >> $PATH_TO_FILE"/last_check"
		echo -e "A new blog post is waiting for translation\n\"$new_post\"" | /bin/mail -s "New entry on English Blog" mageia-blogteam@mageia.org
		echo $DATE
fi

# Clean tmp files and copy RSS_new to RSS_old
/bin/mv -f $PATH_TO_FILE"/RSS_new" $PATH_TO_FILE"/RSS_old"
