class bcd::web {
    include bcd::base
    $location = "$bcd::home/public_html"

    apache::vhost_base { "bcd.$::domain":
        location => $location,
        content  => template('bcd/vhost_bcd.conf'),
    }

    # not sure if that's useful, since the file is public and trivially
    # bruteforced
    file { "$bcd::home/htpasswd":
        content => template('bcd/htpasswd')
    }
}
