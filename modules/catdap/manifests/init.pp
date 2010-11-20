class catdap {

    $catdap_location = "/var/www/identity"
    $catdap_vhost = "identity.$domain"

    # TODO switch to a proper rpm packaging
    $rpm_requirement = ['perl-Catalyst-Runtime',"perl-FCGI", 'perl-Catalyst-Plugin-Authorization-Roles', 
"perl-Catalyst-Action-RenderView", "perl-Catalyst-Model-LDAP-FromAuthentication", "perl-Catalyst-P-A-Store-LDAP", "perl-Catalyst-Plugin-Authentication", "perl-Catalyst-Plugin-Captcha",
"perl-Catalyst-Plugin-ConfigLoader", "perl-Catalyst-Plugin-I18N", "perl-Catalyst-Plugin-Session-Store-File", "perl-Catalyst-Plugin-Static-Simple",
"perl-Catalyst-P-S-State-Cookie", "perl-Catalyst-P-S-Store-File", "perl-Catalyst-View-Email",
"perl-Catalyst-View-TT", "perl-Config-General", "perl-Crypt-CBC", "perl-Data-UUID",
"perl-Email-Valid", "perl-Moose", "perl-namespace-autoclean", "perl-Test-Simple",
"perl-Crypt-Blowfish", "perl-Email-Date-Format", "perl-YAML-LibYAML",
]

    package { $rpm_requirement:
        ensure => installed
    }

    subversion::snapshot { $catdap_location:
        source => "svn://svn.mageia.org/soft/identity/CatDap/branches/live"
    }

    $catdap_password = extlookup('catdap_password')
    
    file { "$catdap_location/catdap_local.yml":
        ensure => present,
	owner => root,
        group => apache,
        mode => 640,
        content => template("catdap/catdap_local.yml"),
        require => Subversion::Snapshot[$catdap_location]
    }

    apache::vhost_catalyst_app { $catdap_vhost:
        script => "$catdap_location/script/catdap_fastcgi.pl",
        location => $catdap_location,
        use_ssl => true,
    }

    apache::vhost_redirect_ssl { $catdap_vhost: }
}
