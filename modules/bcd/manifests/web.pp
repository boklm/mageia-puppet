class bcd::web {
    include bcd::base
    $location = "$bcd::home/public_html"

    apache::vhost::base { "bcd.$::domain":
        location => $location,
        content  => template('bcd/vhost_bcd.conf'),
    }
}
