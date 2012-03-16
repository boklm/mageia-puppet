class buildsystem {
    class youri_submit {

        $packages_archivedir = "$sched_home_dir/old"

        include sudo

        local_script {
            "mga-youri-submit": content => template("buildsystem/mga-youri-submit");
            "mga-youri-submit.wrapper": content => template("buildsystem/mga-youri-submit.wrapper");
            "submit_package": content => template('buildsystem/submit_package.pl');
        }

        sudo::sudoers_config { "mga-youri-submit":
            content => template("buildsystem/sudoers.youri")
        }

        package { "rpmlint": }

        file { "/etc/rpmlint/config":
            require => Package['rpmlint'],
            content => template("buildsystem/rpmlint.conf")
        }

        # directory that hold configuration auto extracted after upload
        # of the rpmlint policy
        file { "/etc/rpmlint/extracted.d/":
            ensure => directory,
            require => Package['rpmlint'],
            owner => $sched_login,
        }

        # ordering is automatic :
        # http://docs.puppetlabs.com/learning/ordering.html#autorequire
        file { "/etc/youri":
            ensure => "directory",
        }

        file {
            "/etc/youri/submit-todo.conf": content => template("buildsystem/submit-todo.conf");
            "/etc/youri/submit-upload.conf": content => template("buildsystem/submit-upload.conf");
            "/etc/youri/acl.conf": content => template("buildsystem/youri_acl.conf");
        }

        file { $packages_archivedir:
            ensure  => 'directory',
            owner   => $sched_login,
            require => File[$sched_home_dir],
        }

        tidy { $packages_archivedir:
            type    => 'ctime',
            recurse => true,
            age     => '1w',
            matches => '*.rpm',
        }

        # FIXME use /usr/local/ once it will be in @INC
        file { '/usr/lib/perl5/vendor_perl/5.12.3/Youri/Repository/Mageia.pm':
            source => "puppet:///modules/buildsystem/Mageia.pm",
        }

        $package_list = ['perl-SVN', 'mdv-distrib-tools', 'perl-Youri-Media',
                         'perl-Youri-Package', 'perl-Youri-Repository',
                         'perl-Youri-Utils', 'perl-Youri-Config', 'mga-youri-submit']

        package { $package_list: }
    }

    # $groups: array of secondary groups (only local groups, no ldap)
    define sshuser($homedir, $comment, $groups = []) {
        group {"$title": 
            ensure => present,
        }

        user {"$title":
            ensure => present,
            comment => $comment,
            managehome => true,
	    home => $homedir,
            gid => $title,
	    groups => $groups,
            shell => "/bin/bash",
            notify => Exec["unlock$title"],
            require => Group[$title],
        }

        # set password to * to unlock the account but forbid login through login
        exec { "unlock$title":
            command => "usermod -p '*' $title",
            refreshonly => true,
        }

        file { $homedir:
            ensure => "directory",
            owner  => $title,
            group  => $title,
            require => User[$title],
        }

        file { "$homedir/.ssh":
            ensure => "directory",
            mode   => 600,
            owner  => $title,
            group  => $title,
            require => File[$homedir],
        }
    }

    # A script to copy on valstar the 2010.1 rpms built on jonund
    class sync20101 inherits base {
        $build_login = $buildsystem::iurt::user::login
        # TODO user iurt::user::homedir too
        local_script { "sync2010.1":
	        content => template("buildsystem/sync2010.1"),
        }
    }

    # a script to build 2010.1 packages. used on jonund
    class iurt20101 inherits base {
        $build_login = $buildsystem::iurt::user::login
        local_script { "iurt2010.1":
	        content => template("buildsystem/iurt2010.1"),
        }
    }
}
