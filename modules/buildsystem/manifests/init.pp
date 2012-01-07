class buildsystem {

    class base {
	$build_login = "iurt"
	$build_home_dir = "/home/$build_login"
	$sched_login = "schedbot"
	$sched_home_dir = "/var/lib/$sched_login"
	$packages_archivedir = "$sched_home_dir/old"
	$repository_root = "/distrib/bootstrap"
	$mirror_root = "/distrib/mirror"
	$packagers_group = 'mga-packagers'
	$packagers_committers_group = 'mga-packagers-committers'
	$createsrpm_path = '/usr/share/mgarepo/create-srpm'

	include ssh::auth
	ssh::auth::key { $build_login: # declare a key for build bot: RSA, 2048 bits
		home => $build_home_dir,
	}
	ssh::auth::key { $sched_login: # declare a key for sched bot: RSA, 2048 bits
		home => $sched_home_dir,
	}
    }

    class mainnode inherits base {
        include iurtuser

        sshuser { $sched_login:
          homedir => $sched_home_dir,
          comment => "System user used to schedule builds",
        }

        ssh::auth::client { $sched_login: }
        ssh::auth::server { $sched_login: }
        ssh::auth::server { $build_login: }

        # FIXME Add again task-bs-cluster-main when it will require mgarepo instead of repsys
        $package_list = ['iurt']
        package { $package_list:
            ensure => "installed"
        }

        apache::vhost_other_app { "repository.$domain":
            vhost_file => "buildsystem/vhost_repository.conf",
        }

        $location = "/var/www/bs"
        file { "$location":
            ensure => directory,
        }

        file { "$location/data":
            ensure => directory,
            require => File[$location],
        }

        apache::vhost_base { "pkgsubmit.$domain":
            aliases => { "/uploads" => "$sched_home_dir/uploads" },
            location => $location,
	    content => template("buildsystem/vhost_pkgsubmit.conf"),
        }

        subversion::snapshot { $location:
            source => "svn://svn.$domain/soft/buildsystem/web/",
        }

	file { "$repository_root/distrib/cauldron/i586/media/media_info/media.cfg":
	    ensure => present,
	    owner => $sched_login,
	    group => $sched_login,
	    mode => 644,
	    source => "puppet:///modules/buildsystem/i586/media.cfg",
	}

	file { "$repository_root/distrib/cauldron/x86_64/media/media_info/media.cfg":
	    ensure => present,
	    owner => $sched_login,
	    group => $sched_login,
	    mode => 644,
	    source => "puppet:///modules/buildsystem/x86_64/media.cfg",
	}

        include scheduler
        include gatherer
        include buildsystem::mgarepo
        include youri_submit
        include buildsystem::check_missing_deps
        include buildsystem::signbot
    }

    class buildnode inherits base {
        include iurt
    }

    class scheduler {
        # ulri        
        include iurtupload
    }

    class gatherer {
        # emi
        include iurtupload
    }

    class iurtupload {
        file { "/etc/iurt/upload.conf":
            ensure => present,
            owner => $build_login,
            group => $build_login,
            mode => 644,
            require => File["/etc/iurt"],
            content => template("buildsystem/upload.conf")
        }
    }

    class maintdb inherits base {
    	include sudo
        $maintdb_login = "maintdb"
	$maintdb_homedir = "/var/lib/maintdb"
	$maintdb_dbdir = "$maintdb_homedir/db"
	$maintdb_binpath = "/usr/local/sbin/maintdb"
	$maintdb_wrappath = "/usr/local/bin/wrapper.maintdb"
        $maintdb_dump = "/var/www/bs/data/maintdb.txt"
	$maintdb_unmaintained = "/var/www/bs/data/unmaintained.txt"

	user {"$maintdb_login":
            ensure => present,
            comment => "Maintainers database",
	    managehome => true,
	    shell => "/bin/bash",
	    home => "$maintdb_homedir",
	}

	file { "$maintdb_homedir":
	    ensure => directory,
	    owner => "$maintdb_login",
	   group => "$maintdb_login",
	   mode => 711,
	   require => User["$maintdb_login"],
	}

	file { "$maintdb_dbdir":
	   ensure => directory,
	   owner => "$maintdb_login",
	   group => "$maintdb_login",
	   mode => 711,
	   require => User["$maintdb_login"],
	}

	file { "$maintdb_binpath":
	   ensure => present,
	   owner => root,
	   group => root,
	   mode => 755,
	   content => template("buildsystem/maintdb")
	}

	file { "$maintdb_wrappath":
	   ensure => present,
	   owner => root,
	   group => root,
	   mode => 755,
	   content => template("buildsystem/wrapper.maintdb")
	}

	sudo::sudoers_config { "maintdb":
	    content => template("buildsystem/sudoers.maintdb")
	}

        file { ["$maintdb_dump","$maintdb_dump.new"]:
            ensure => present,
            owner => $maintdb_login,
            mode => 644,
            require => File["/var/www/bs/data"],
        }

	cron { "update maintdb export":
	    user => $maintdb_login,
	    command => "$maintdb_binpath root get > $maintdb_dump.new; mv -f $maintdb_dump.new $maintdb_dump; grep ' nobody\$' $maintdb_dump | sed 's/ nobody\$//' > $maintdb_unmaintained.new; mv -f $maintdb_unmaintained.new $maintdb_unmaintained",
	    minute => "*/30",
        require => User[$maintdb_login],
	}

	apache::vhost_base { "maintdb.$domain":
	    location => $maintdb_dbdir,
	    content => template("buildsystem/vhost_maintdb.conf"),
	}
    }

    class binrepo inherits base {
        include sudo
        $binrepo_login = "binrepo"
	$binrepo_homedir = "/var/lib/$binrepo_login"
        $binrepodir = "$binrepo_homedir/data"
	$uploadinfosdir = "$binrepo_homedir/infos"
	$uploadbinpath = '/usr/local/bin/upload-bin'
	$uploadbinpathwrapper = '/usr/local/bin/wrapper.upload-bin'
	$uploadmail_from = "root@$domain"
	$uploadmail_to = "packages-commits@ml.$domain"

	user {"$binrepo_login":
	    ensure => present,
	    comment => "Binary files repository",
	    managehome => true,
	    shell => "/bin/bash",
	    home => "$binrepo_homedir",
	}

	file { $binrepodir:
	    ensure => directory,
	    owner => $binrepo_login,
	    group => $binrepo_login,
	    mode => 755,
	}

	file { $uploadinfosdir:
	    ensure => directory,
	    owner => $binrepo_login,
	    group => $binrepo_login,
	    mode => 755,
	}

        file { $uploadbinpath:
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 755,
	    content => template('buildsystem/upload-bin'),
	}

        file { $uploadbinpathwrapper:
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 755,
	    content => template('buildsystem/wrapper.upload-bin'),
	}

	sudo::sudoers_config { "binrepo":
	    content => template("buildsystem/sudoers.binrepo")
	}

	apache::vhost_base { "binrepo.$domain":
	    location => $binrepodir,
	    content => template("buildsystem/vhost_binrepo.conf"),
	}
    }
    
    class youri_submit {
        include sudo

        file { "/usr/local/bin/mga-youri-submit":
          owner  => root,
          group => root,
          mode => 755,
          content => template("buildsystem/mga-youri-submit")
        }

        file { "/usr/local/bin/mga-youri-submit.wrapper":
          owner  => root,
          group => root,
          mode => 755,
          content => template("buildsystem/mga-youri-submit.wrapper")
        }

	sudo::sudoers_config { "mga-youri-submit":
            content => template("buildsystem/sudoers.youri")
        }

        package { "rpmlint": }

        file { "/etc/rpmlint/config":
            ensure => present,
            mode => 644,
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

        file { "/etc/youri":
            ensure => "directory",
        }

        file { "/etc/youri/submit-todo.conf":
            ensure => present,
            mode => 644,
            require => File["/etc/youri"],
            content => template("buildsystem/submit-todo.conf")
        }

        file { "/etc/youri/submit-upload.conf":
            ensure => present,
            mode => 644,
            require => File["/etc/youri"],
            content => template("buildsystem/submit-upload.conf")
        }

        file { "/etc/youri/acl.conf":
            ensure => present,
            mode => 644,
            require => File["/etc/youri"],
            content => template("buildsystem/youri_acl.conf")
        }

	file { '/usr/local/bin/submit_package':
	    ensure => present,
	    mode => 755,
	    content => template('buildsystem/submit_package.pl')
        }

	# FIXME use the correct perl directory
        file { "/usr/lib/perl5/site_perl/5.10.1/Youri/Repository":
            ensure => "directory",
        }

	file { '/usr/lib/perl5/site_perl/5.10.1/Youri/Repository/Mageia.pm':
            ensure => present,
            mode => 644,
            require => File["/usr/lib/perl5/site_perl/5.10.1/Youri/Repository"],
            source => "puppet:///modules/buildsystem/Mageia.pm",
        }

        $package_list = ['perl-SVN', 'mdv-distrib-tools', 'perl-Youri-Media',
                         'perl-Youri-Package', 'perl-Youri-Repository',
                         'perl-Youri-Utils', 'perl-Youri-Config', 'mga-youri-submit']

        package { $package_list:
            ensure => installed;
        }
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

    class iurtuser {
        sshuser { $build_login:
          homedir => $build_home_dir,
          comment => "System user used to run build bots",
        }

        file { "/etc/iurt":
            ensure => "directory",
        }
    }

    class iurt {
        include sudo
        include iurtuser
        ssh::auth::client { $build_login: }
        ssh::auth::server { $sched_login: user => $build_login }

        $tidy_age = "8w"
        # remove old build directory
        tidy { "$build_home_dir/iurt":
            age => $tidy_age,
            recurse => true,
            matches => ['[0-9][0-9].*\..*\..*\.[0-9]*',"log","*.rpm","*.log","*.mga[0-9]+"],
            rmdirs => true,
        }

        # build node common settings
        # we could have the following skip list to use less space:
        # '/(drakx-installer-binaries|drakx-installer-advertising|gfxboot|drakx-installer-stage2|mandriva-theme)/'
        $package_list = ['task-bs-cluster-chroot', 'iurt']
        package { $package_list:
            ensure => installed;
        }

        file { "/etc/iurt/build":
            ensure => "directory",
            require => File["/etc/iurt"],
        }

        define iurt_config() {

            $distribution = $name
            file { "/etc/iurt/build/$distribution.conf":
                ensure => present,
                owner => $build_login,
                group => $build_login,
                mode => 644,
                require => File["/etc/iurt/build"],
                content => template("buildsystem/iurt.$distribution.conf")
            }
        }

        iurt_config { "1": }
        iurt_config { "mandriva2010.1": }
        iurt_config { "cauldron": }

       	sudo::sudoers_config { "iurt":
            content => template("buildsystem/sudoers.iurt")
        }
    }

    # A script to copy on valstar the 2010.1 rpms built on jonund
    class sync20101 inherits base {
       file { "/usr/local/bin/sync2010.1":
           ensure => present,
	   owner => root,
	   group => root,
	   mode => 755,
	   content => template("buildsystem/sync2010.1"),
       }
    }

    # a script to build 2010.1 packages. used on jonund
    class iurt20101 inherits base {
       file { "/usr/local/bin/iurt2010.1":
           ensure => present,
	   owner => root,
	   group => root,
	   mode => 755,
	   content => template("buildsystem/iurt2010.1"),
       }
    }
}
