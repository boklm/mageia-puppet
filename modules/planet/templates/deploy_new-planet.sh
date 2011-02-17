#!/bin/sh

# Initialization
PATH_TO_FILE=${PATH_TO_FILE:-/var/lib/planet}
PATH_TO_PLANET=${PATH_TO_PLANET:-/var/www/html/planet<%= domain %>}

#Ask for new locale name if no parameter given
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
		/bin/mkdir $FILE
	fi
else
	echo "Aborted, please try again."
	exit 2
fi
