define bind::zone($type, $content = false) {
    if ! $content {
        $zone_content = template("bind/zones/$name.zone")
    } else {
        $zone_content = $content
    }
    file { "/var/lib/named/var/named/$type/$name.zone":
        content => $zone_content,
        require => Package['bind'],
        notify  => Exec['named_reload']
    }
}
