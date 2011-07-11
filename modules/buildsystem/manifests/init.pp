class buildsystem {

    class base {
	$build_login = "iurt"
	$build_home_dir = "/home/$build_login"
	$sched_login = "schedbot"
	$sched_home_dir = "/var/lib/$sched_login"
	$packages_archivedir = "$sched_home_dir/old"
	$sign_login = "signbot"
	$sign_home_dir = "/var/lib/$sign_login"
	$sign_keydir = "$sign_home_dir/keys"
	# FIXME: maybe keyid should be defined at an other place
	$sign_keyid = "80420F66"
	$repository_root = "/distrib/bootstrap"
	$mirror_root = "/distrib/mirror"
	$maintdb_url = 'http://www.maintdb2.mageia.org.uk/maintainers_packages/create'
	# FIXME: Test password. Real password should be in extdata.
	$maintdb_key = 'm1g234'
	$packagers_group = 'mga-packagers'
	$createsrpm_path = '/usr/share/repsys/create-srpm'

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
        include mgarepo
        include youri_submit
        include check_missing_deps 
	include signbot
    }

    class buildnode inherits base {
        include iurt
    }

    class signbot {
	sshuser { $sign_login:
          homedir => $sign_home_dir,
          comment => "System user used to sign packages",
	  groups => [$sched_login],
        }

	gnupg::keys{"packages":
          email => "packages@$domain",
	  #FIXME there should be a variable somewhere to change the name of the distribution
  	  key_name => 'Mageia Packages',
	  login => $sign_login,
	  batchdir => "$sign_home_dir/batches",
	  keydir => $sign_keydir,
	}

	sudo::sudoers_config { "signpackage":
            content => template("buildsystem/sudoers.signpackage")
        }

	file { "$sign_home_dir/.rpmmacros":
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 644,
	    content => template("buildsystem/signbot-rpmmacros")
	}

	file { "/usr/local/bin/sign-check-package":
	    ensure => present,
	    owner => root,
	    group => root,
	    mode => 755,
	    content => template("buildsystem/sign-check-package")
	}
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

    class maintdb {
        $maintdb_login = "maintdb"
	$maintdb_homedir = "/var/lib/maintdb"
	$maintdb_dbdir = "$maintdb_homedir/$db"
	$maintdb_binpath = "/usr/local/sbin/maintdb"
	$maintdb_wrappath = "/usr/local/bin/wrapper.maintdb"

	user {"$maintdb_login":
            ensure => present,
            comment => "Maintainers database",
	    managehome => true,
	    gid => $maintdb_login,
	    shell => "/bin/bash",
	    home => "$maintdb_homedir",
	}

	file { "$maintdb_dbdir":
	   ensure => directory,
	   owner => "$maintdb_login",
	   group => "$maintdb_login",
	   mode => 700,
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
    }
    
    class mgarepo {
        package { 'mgarepo':

        }

        package { 'rpm-build':
        }

        file { "repsys.conf":
          path => "/etc/repsys.conf",
          owner  => root,
          group => root,
          mode => 644,
          content => template("buildsystem/repsys.conf")
        }

        file { "$packages_archivedir":
            ensure => "directory",
            owner  => $sched_login,
            require => File[$sched_home_dir],
        }

        file { "$sched_home_dir/repsys":
            ensure => "directory",
            owner  => $sched_login,
            require => File[$sched_home_dir],
        }

        file { ["$sched_home_dir/repsys/tmp", "$sched_home_dir/repsys/srpms"]:
            ensure => "directory",
            owner  => $sched_login,
            group => "mga-packagers",
            mode => 1775,
            require => File["$sched_home_dir/repsys"],
        }

	# FIXME: disabled temporarly as upload dir is a symlink to /var/lib/repsys/uploads
        #file { "$sched_home_dir/uploads":
        #    ensure => "directory",
        #    owner  => $sched_login,
        #    require => File[$sched_home_dir],
        #}

        # too tedious to create everything by hand
        # so I prefered to used some puppet ruby module
        # the exact content and directory name should IMHO be consolidated somewhere
        import "create_upload_dir.rb"
        create_upload_dir { "$sched_home_dir/uploads":
            owner => $sched_login, 
	    group => $sched_login,
        } 
        
        tidy { "$sched_home_dir/uploads":
            age     => "2w",
            recurse => true,
            type    => "ctime",
        }

        tidy { "$packages_archivedir":
            age     => "1w",
            matches => "*.rpm",
            recurse => true,
            type    => "ctime",
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
	    content => template('buildsystem/submit_package')
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

        file { "/etc/iurt/build/cauldron.conf":
            ensure => present,
            owner => $build_login,
            group => $build_login,
            mode => 644,
            require => File["/etc/iurt/build"],
            content => template("buildsystem/iurt.cauldron.conf")
        }

        file { "/etc/iurt/build/1.conf":
            ensure => present,
            owner => $build_login,
            group => $build_login,
            mode => 644,
            require => File["/etc/iurt/build"],
            content => template("buildsystem/iurt.1.conf")
        }

        file { "/etc/iurt/build/mandriva2010.1.conf":
            ensure => present,
            owner => $build_login,
            group => $build_login,
            mode => 644,
            require => File["/etc/iurt/build"],
            content => template("buildsystem/iurt.mandriva2010.1.conf")
        }

	sudo::sudoers_config { "iurt":
            content => template("buildsystem/sudoers.iurt")
        }
    }

    # temporary script to create home dir with ssh key
    # taking login and url as arguments
    class mgacreatehome {
	file { "/usr/local/sbin/mgacreatehome":
            ensure => present,
            owner => root,
            group => root,
            mode => 700,
            content => template("buildsystem/mgacreatehome")
	}
    }

    class check_missing_deps {
        file { "/usr/local/bin/missing-deps.sh":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/buildsystem/missing-deps.sh",
        }
    
        # FIXME hardcoded path
        cron { "check missing deps":
            command => "cd /var/www/bs/data && /usr/local/bin/missing-deps.sh",
            minute => "*/15",
        }
    }

    class release {
	subversion::snapshot { "/root/release":
	    source => "svn://svn.$domain/soft/release/trunk/",
	}

        package { "hardlink":
	    ensure => "installed",
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
