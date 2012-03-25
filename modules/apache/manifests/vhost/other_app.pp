define apache::vhost::other_app($vhost_file) {
    include apache::base
    apache::config { "/etc/httpd/conf/vhosts.d/$name.conf":
        content => template($vhost_file),
    }
}
