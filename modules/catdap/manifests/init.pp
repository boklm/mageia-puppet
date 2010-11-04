class catdap {

    include subversion
    include subversion::client
    include apache::mod_fcgid

    $catdap_location = "/var/www/identity"

    # TODO switch to a proper rpm packaging
    $rpm_requirement = ['perl-Catalyst-Runtime', 
"perl-Catalyst-Action-RenderView", "perl-Catalyst-Model-LDAP-FromAuthentication", "perl-Catalyst-P-A-Store-LDAP", "perl-Catalyst-Plugin-Authentication", "perl-Catalyst-Plugin-Captcha",
"perl-Catalyst-Plugin-ConfigLoader", "perl-Catalyst-Plugin-I18N", "perl-Catalyst-Plugin-Session-Store-File", "perl-Catalyst-Plugin-Static-Simple",
"perl-Catalyst-P-S-State-Cookie", "perl-Catalyst-P-S-Store-File", "perl-Catalyst-Runtime", "perl-Catalyst-View-Email",
"perl-Catalyst-View-TT", "perl-Config-General", "perl-Crypt-CBC", "perl-Data-UUID",
"perl-Email-Valid", "perl-Moose", "perl-namespace-autoclean", "perl-Test-Simple" ]

    package { $rpm_requirement:
        ensure => installed
    }

    subversion::snapshot { $catdap_location:
        source =>   "svn+ssh://svn.mageia.org/srv/mx2-dd0/svn/soft/identity/CatDap/branches/live"
    }

    # add a catdap config file
    file { "$catdap_location/catdap_local.yml":
        ensure => present,
        owner => apache,
        mode => 600,
        content => template("catdap/catdap_local.yml") 
    }

    # add a apache vhost
    file { "identity.$domain.conf":
        path => "/etc/httpd/conf/vhosts.d/$name",
        ensure => "present",
        owner => root,
        group => root,
        mode => 644,
        notify => Service['apache'],
        content => template("catdap/catdap_vhost.conf")
    }    
}
