class puppet::thin {
    package { 'ruby-thin': }
   
    apache::config { "/etc/httpd/conf.d/puppet.conf":
                content => "Listen 8140",
    }
}
