#!/bin/sh

# Initialization
PATH_TO_FILE=${PATH_TO_FILE:-/var/lib/planet}
PATH_TO_PLANET=${PATH_TO_PLANET:-/var/www/html/planet.<%= domain %>}

#Ask for new locale name
echo -n "Locale name: "
read locale

# Display the answer and ask for confirmation
echo -e -n "Do you confirm the entry: \"$locale\"? (y/n) "
read answer
if [ "$answer" == "y" ] 
then
	FILE="$PATH_TO_PLANET/$locale/"
	if test -d $FILE
	then
		echo "Aborted, $FILE already exist."
		exit 2
	else
		# Deploy new planet with locale given
		/bin/mkdir $FILE
		/bin/chown planet:apache $FILE
		/usr/bin/wget -O $PATH_TO_FILE"/moonmoon.tar.gz" http://damsweb.net/files/moonmoon_mageia.tar.gz
		if [ $? -ne 0 ]
		then
			echo "Aborted, can't download GZIP file"
			exit 2
		fi
		/bin/tar zxvf $PATH_TO_FILE/moonmoon.tar.gz -C $FILE
		/bin/mkdir $FILE"cache"
		/bin/chown -R planet:apache $FILE
		/bin/chmod g+w $FILE"custom" $FILE"custom/people.opml" $FILE"admin/inc/pwd.inc.php" $FILE"cache"
		echo -e "Info: a new Planet had been deployed.\nThe locale is: \"$locale\" - http://planet.<%= domain %>/$locale\n-- \nMail sent by the script '$0' on `hostname`" | /bin/mail -s "New planet Mageia deployed" mageia-webteam@<%= domain %>,mageia-marcom@<%= domain %>
	fi
else
	echo "Aborted, please try again."
	exit 2
fi
