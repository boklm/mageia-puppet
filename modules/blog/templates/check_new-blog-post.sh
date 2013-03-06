#!/bin/sh

# Initialization
PATH_TO_FILE=${PATH_TO_FILE:-/var/lib/blog}
/usr/bin/wget -qO $PATH_TO_FILE"/last_tmp" http://blog.mageia.org/en/?feed=rss2
if [ $? -ne 0 ] 
then
	exit 2
fi
last_title=$(grep "title" $PATH_TO_FILE"/last_tmp" | head -n 2 | sed '1d' | sed 's/<title>//' | sed 's/<\/title>//' | sed 's/^[ \t]*//')
last_pub=$(grep "pubDate" $PATH_TO_FILE"/last_tmp" | head -n 1 | sed 's/<pubDate>//' | sed 's/<\/pubDate>//' | sed 's/^[ \t]*//')
last_creator=$(grep "creator" $PATH_TO_FILE"/last_tmp" | head -n 1 | sed 's/<dc:creator>//' | sed 's/<\/dc:creator>//' | sed 's/^[ \t]*//')
echo -e "$last_title\n$last_pub\n$last_creator" > $PATH_TO_FILE"/last_tmp"

# Check if 'last_entry' exists
if [ ! -f $PATH_TO_FILE"/last_entry" ]
	then
		/bin/mv -f $PATH_TO_FILE"/last_tmp" $PATH_TO_FILE"/last_entry"
		exit 1
fi

# Add a date file for log
/bin/date +"%d:%m:%Y %H:%M" > $PATH_TO_FILE"/last_check"

# Check if a new blog post on EN needs to be translated on other blogs
tmp_new=$(cat $PATH_TO_FILE"/last_tmp" | sed -n '1p')
tmp_old=$(cat $PATH_TO_FILE"/last_entry" | sed -n '1p')
if [ "$tmp_old" = "$tmp_new" ]
	then
		# Nothing new
		tmp_new=$(cat $PATH_TO_FILE"/last_tmp" | sed -n '2p')
		tmp_old=$(cat $PATH_TO_FILE"/last_entry" | sed -n '2p')
		if [ "$tmp_old" != "$tmp_new" ]
			then 
				# Modification on lastest post
				echo "YES - Modification" >> $PATH_TO_FILE"/last_check"
				echo -e "The latest blog post has been modified and needs to be checked!\n\nTitle:\t$last_title\nAuthor:\t$last_creator\n-- \nMail sent by the script '$0' on `hostname`" | /bin/mail -r "Mageia Blog bot <mageia-blogteam@<%= domain %>>" -s "Modification of the lastest entry on English Blog" mageia-blogteam@<%= domain %>
				echo $DATE
			else
				echo "NO" >> $PATH_TO_FILE"/last_check"
		fi
	else
		# New post to translate
		echo "YES - New entry" >> $PATH_TO_FILE"/last_check"
		echo -e "A new blog post is waiting for translation:\n\nTitle:\t$last_title\nAuthor:\t$last_creator\n-- \nMail sent by the script '$0' on `hostname`" | /bin/mail -r "Mageia Blog bot <mageia-blogteam@<%= domain %>>" -s "New entry on English Blog" mageia-blogteam@<%= domain %>
		echo $DATE
fi

# Clean tmp files and copy RSS_new to RSS_old
/bin/mv -f $PATH_TO_FILE"/last_tmp" $PATH_TO_FILE"/last_entry"
