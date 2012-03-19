define sympa::datasource::ldap_group {
    file { "/etc/sympa/data_sources/$name.incl":
        content => template('sympa/data_sources/ldap_group.incl')
    }
}
