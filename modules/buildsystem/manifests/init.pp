class buildsystem {

    class base {
	$build_login = "iurt"
	$build_home_dir = "/home/$build_login"
	$sched_login = "schedbot"
	$sched_home_dir = "/var/lib/$sched_login"
	$packages_archivedir = "$sched_home_dir/old"
	$repository_root = "/distrib/bootstrap"
	$packagers_group = 'mga-packagers'
	$packagers_committers_group = 'mga-packagers-committers'

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

        ssh::auth::server { [$sched_login, $build_login]: }

        # FIXME Add again task-bs-cluster-main when it will require mgarepo instead of repsys
        $package_list = ['iurt']
        package { $package_list: }

        $mirror_root = "/distrib/mirror"
        apache::vhost_other_app { "repository.$domain":
            vhost_file => "buildsystem/vhost_repository.conf",
        }

        $location = "/var/www/bs"
        file { ["$location","$location/data"]:
            ensure => directory,
        }

        apache::vhost_base { "pkgsubmit.$domain":
            aliases => { "/uploads" => "$sched_home_dir/uploads" },
            location => $location,
	    content => template("buildsystem/vhost_pkgsubmit.conf"),
        }

        subversion::snapshot { $location:
            source => "svn://svn.$domain/soft/buildsystem/web/",
        }

        define media_cfg() {
            $arch = $name
            file { "$repository_root/distrib/cauldron/$arch/media/media_info/media.cfg":
	            owner => $sched_login,
	            group => $sched_login,
	            source => "puppet:///modules/buildsystem/$arch/media.cfg",
	        }
        }

        media_cfg { ["i586","x86_64"]: }

        include scheduler
        include gatherer
        include buildsystem::mgarepo
        include buildsystem::signbot
        include youri_submit
        include buildsystem::check_missing_deps

        cron { "dispatch jobs":
            user => $sched_login,
            command => "emi ; ulri",
            minute => "*",
        }
    }

    class buildnode inherits base {
        include buildsystem::iurt
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
            require => File["/etc/iurt"],
            content => template("buildsystem/upload.conf")
        }
    }

    class youri_submit {
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

        # FIXME use the correct perl directory
        file { "/usr/lib/perl5/site_perl/5.10.1/Youri/Repository":
            ensure => "directory",
        }

        file { '/usr/lib/perl5/site_perl/5.10.1/Youri/Repository/Mageia.pm':
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

    class iurtuser {
        sshuser { $build_login:
          homedir => $build_home_dir,
          comment => "System user used to run build bots",
        }

        file { "/etc/iurt":
            ensure => "directory",
        }
    }

    # A script to copy on valstar the 2010.1 rpms built on jonund
    class sync20101 inherits base {
        local_script { "sync2010.1":
	        content => template("buildsystem/sync2010.1"),
        }
    }

    # a script to build 2010.1 packages. used on jonund
    class iurt20101 inherits base {
        local_script { "iurt2010.1":
	        content => template("buildsystem/iurt2010.1"),
        }
    }
}
