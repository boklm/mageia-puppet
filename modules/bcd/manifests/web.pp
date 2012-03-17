class bcd::web {
    include bcd::base 
    # TODO simplify this
    $bcd_home = $bcd::home

    apache::vhost_base { "bcd.$::domain":
	    location => "$bcd_home/public_html",
	    content  => template('bcd/vhost_bcd.conf'),
	}

    # TODO should be merged with main file
	file { "$bcd_home/public_html/.htaccess":
	    content => template('bcd/.htaccess')
	}

    # not sure if that's useful, since the file is public and trivially 
    # bruteforced
	file { "$bcd_home/public_html/.htpasswd":
        content => template('bcd/.htpasswd')
    }
}
