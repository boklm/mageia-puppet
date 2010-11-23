class restrictshell {
    class shell {
        file {"/etc/membersh-conf.d":
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        }

        file { '/usr/local/bin/sv_membersh.pl':
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("restrictshell/sv_membersh.pl"),
        }

        file { '/etc/membersh-conf.pl':
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("restrictshell/membersh-conf.pl"),
        }
    }
    
    class ssh_keys_from_ldap {

        package { 'python-ldap':
            ensure => installed,
        }

        $pubkeys_directory = "/var/lib/pubkeys"
        file { $pubkeys_directory:
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        }

        $ldap_pwfile = "/etc/ldap.secret"
        file { '/usr/local/bin/ldap-sshkey2file.py':
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("restrictshell/ldap-sshkey2file.py"),
            requires => Package['python-ldap']
        } 
    }

    define allow {
        include shell
        file { "/etc/membersh-conf.d/allow_$name.pl":
            ensure => "present",
            owner => root,
            group => root,
            mode => 755,
            content => "\$use_$name = 1;\n",
        }
    }

    # yes, we could directly use the allow, but this is
    # a nicer syntax
    class allow_git {
        allow{ "git": }
    }

    class allow_rsync {
        allow{ "rsync": }
    }

    class allow_pkgsubmit {
        allow{ "pkgsubmit": }
    }

    class allow_svn {
        allow{ "svn": }
    }

    class allow_scp {
        allow{ "scp": }
    }

    class allow_sftp {
        allow{ "sftp": }
    }
    # technically, we could add cvs too
    # but I doubt we will use it one day


}
