define openldap::config($content) {
    file { $name:
        require => Package['openldap-servers'],
        content => $content,
        notify  => Exec['/etc/init.d/ldap check'],
    }
}
