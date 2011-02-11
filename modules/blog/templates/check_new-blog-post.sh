#!/bin/sh

# Initialization
REPLYTO=mageia-blogteam@mageia.org
PATH_TO_FILE=${PATH_TO_FILE:-/var/lib/blog}
/usr/bin/wget -qO $PATH_TO_FILE"/last_tmp" http://blog.mageia.org/?feed=rss2
if [ $? -ne 0 ] 
then
        exit 2
fi
last_title=$(grep "title" $PATH_TO_FILE"/last_tmp" | head -n 2 | sed '1d' | sed 's/<title>//' | sed 's/<\/title>//' | sed 's/^[ \t]*//')
last_pub=$(grep "pubDate" $PATH_TO_FILE"/last_tmp" | head -n 1 | sed 's/<pubDate>//' | sed 's/<\/pubDate>//' | sed 's/^[ \t]*//')
echo -e "$last_title\n$last_pub" > $PATH_TO_FILE"/last_tmp"

# Check if 'last_entry' exists
if [ ! -f $PATH_TO_FILE"/last_entry" ]
	then
		/bin/mv -f $PATH_TO_FILE"/last_tmp" $PATH_TO_FILE"/last_entry"
		exit 1
fi

# Add a date file for log
/bin/date +"%d:%m:%Y %H:%M" > $PATH_TO_FILE"/last_check"

# Check if a new blog post on EN needs to be translated on other blogs
tmp_new=$(cat $PATH_TO_FILE"/last_tmp" | sed '1d')
tmp_old=$(cat $PATH_TO_FILE"/last_entry" | sed '1d')
if [ "$tmp_old" = "$tmp_new" ]
	then
		# Nothing new
		echo "NO" >> $PATH_TO_FILE"/last_check"
	else
		tmp_new=$(cat $PATH_TO_FILE"/last_tmp" | sed '2d')
		tmp_old=$(cat $PATH_TO_FILE"/last_entry" | sed '2d')
		if [ "$tmp_old" = "$tmp_new" ]
			then 
				# Modification on last post
				cat $PATH_TO_FILE"/last_check" > $PATH_TO_FILE"/last_need_translation"
				echo $tmp_new >> $PATH_TO_FILE"/last_need_translation"
				echo "YES - Modification" >> $PATH_TO_FILE"/last_check"
				echo -e "Info: the last blog post had been modified and need to be checked.\nTitle: \"$tmp_new\"" | /bin/mail -s "Modification of the last entry on English Blog" mageia-blogteam@mageia.org
				echo $DATE
			else
				# New post to translate
				cat $PATH_TO_FILE"/last_check" > $PATH_TO_FILE"/last_need_translation"
				echo $tmp_new >> $PATH_TO_FILE"/last_need_translation"
				echo "YES - New entry" >> $PATH_TO_FILE"/last_check"
				echo -e "Info: a new blog post is waiting for translation.\nTitle: \"$tmp_new\"" | /bin/mail -s "New entry on English Blog" mageia-blogteam@mageia.org
				echo $DATE
			fi
	fi

# Clean tmp files and copy RSS_new to RSS_old
/bin/mv -f $PATH_TO_FILE"/last_tmp" $PATH_TO_FILE"/last_entry"
