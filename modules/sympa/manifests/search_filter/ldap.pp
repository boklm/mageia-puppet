define sympa::search_filter::ldap {
    file { "/etc/sympa/search_filters/$name.ldap":
        content => template('sympa/search_filters/group.ldap')
    }
}
