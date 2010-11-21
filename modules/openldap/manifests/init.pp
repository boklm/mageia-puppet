class openldap {
    class base {
        package { 'openldap-servers':
            ensure => installed 
        }

        service { ldap:
            ensure => running,
            subscribe => [ Package['openldap-servers']],
            path => "/etc/init.d/ldap"
        }

        file {"/etc/ssl/openldap/":
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        }

        $pem_file = 'ldap.pem'
        exec { "openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout $pem_file -out $pem_file -subj  '/CN=ldap.$domain'":
            cwd => "/etc/ssl/openldap/",
            creates => "/etc/ssl/openldap/$pem_file"
        }
    }

    # /etc/
    # 11:57:48|  blingme> misc: nothing special, just copy slapd.conf, mandriva-dit-access.conf across, slapcat one side, slapadd other side

    file { '/etc/openldap/slapd.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["openldap-servers"],
        content => "",
        notify => [Service['ldap']]
    }

    file { '/etc/openldap/mandriva-dit-access.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["openldap-servers"],
        content => "",
        notify => [Service['ldap']]
    }

    file { '/etc/sysconfig/ldap':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Package["openldap-servers"],
        content => "",
        notify => [Service['ldap']]
    } 

    class master inherits base {
        file { '/etc/openldap/mandriva-dit-access.conf':
            content => template("openldap/mandriva-dit-access.conf"),
        }

        file { '/etc/openldap/slapd.conf':
            content => template("openldap/slapd.conf"),
        }

        file { '/etc/sysconfig/ldap':
            content => template("openldap/ldap.sysconfig"),
        }
    }
}
