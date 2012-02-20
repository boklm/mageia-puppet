class catdap {

    $upstream_svn = 'svn://svn.mageia.org/svn/soft/identity/CatDap/'

    # TODO switch to a proper rpm packaging
    $rpm_requirement = ['perl-Catalyst-Runtime',
                        'perl-FCGI',
                        'perl-Catalyst-Plugin-Authorization-Roles',
                        'perl-Catalyst-Action-RenderView',
                        'perl-Catalyst-Model-LDAP-FromAuthentication',
                        'perl-Catalyst-P-A-Store-LDAP',
                        'perl-Catalyst-Plugin-Authentication',
                        'perl-Catalyst-Plugin-Captcha',
                        'perl-Catalyst-Plugin-ConfigLoader',
                        'perl-Catalyst-Plugin-I18N',
                        'perl-Catalyst-Plugin-Session-Store-File',
                        'perl-Catalyst-Plugin-Static-Simple',
                        'perl-Catalyst-P-S-State-Cookie',
                        'perl-Catalyst-P-S-Store-File',
                        'perl-Catalyst-View-Email',
                        'perl-Catalyst-View-TT',
                        'perl-Config-General',
                        'perl-Crypt-CBC',
                        'perl-Data-UUID',
                        'perl-Email-Valid',
                        'perl-Moose',
                        'perl-namespace-autoclean',
                        'perl-Test-Simple',
                        'perl-Crypt-Blowfish',
                        'perl-Email-Date-Format',
                        'perl-YAML-LibYAML',
                        'perl-Catalyst-Plugin-Unicode-Encoding',
                        'perl-IO-Socket-INET6' ]

    package { $rpm_requirement: }

    $ldap_password = extlookup('catdap_ldap','x')

    define catdap_snapshot($location, $svn_location) {
        file { "$location/catdap_local.yml":
            group   => apache,
            mode    => '0640',
            content => template('catdap/catdap_local.yml'),
            require => Subversion::Snapshot[$location],
        }

        subversion::snapshot { $location:
            source => $svn_location
        }

        apache::vhost_catalyst_app { $name:
            script   => "$location/script/catdap_fastcgi.pl",
            location => $location,
            use_ssl  => true,
        }

        apache::vhost_redirect_ssl { $name: }
    }

    catdap_snapshot { "identity.$::domain":
        location     => '/var/www/identity',
        svn_location => "$upstream_svn/branches/live"
    }

    catdap_snapshot { "identity-trunk.$::domain":
        location     => '/var/www/identity-trunk',
        svn_location => "$upstream_svn/trunk"
    }
}
