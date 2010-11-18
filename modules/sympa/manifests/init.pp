class sympa {

    $package_list = ['sympa', 'sympa-www']

    package { $package_list:
        ensure => installed;
    }

    $password = extlookup("sympa_password")
    $ldappass = extlookup("sympa_ldap")

    file { '/etc/sympa/sympa.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("sympa/sympa.conf")
    }

    file { '/etc/sympa/auth.conf':
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        content => template("sympa/auth.conf")
    }


    include apache::mod_fcgid
    apache::webapp_other{"sympa":
	webapp_file => "sympa/webapp_sympa.conf",
    }

   apache::vhost_other_app { "ml.$domain":
        vhost_file => "sympa/vhost_ml.conf",
   }
}

