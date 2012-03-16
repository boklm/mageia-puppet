class buildsystem {
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
