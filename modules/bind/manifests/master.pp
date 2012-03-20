class bind::master inherits bind {
    Tld_redirections::Domain <<| |>>

    $managed_tlds = list_exported_ressources('Tld_redirections::Domain')
    File['/var/lib/named/etc/named.conf'] {
        content => template('bind/named_base.conf', 'bind/named_master.conf'),
    }
}
