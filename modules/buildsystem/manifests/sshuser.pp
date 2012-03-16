# $groups: array of secondary groups (only local groups, no ldap)
define buildsystem::sshuser($homedir, $comment, $groups = []) {
    group { $name: }

    user { $name:
        comment    => $comment,
        managehome => true,
        home       => $homedir,
        gid        => $name,
        groups     => $groups,
        shell      => '/bin/bash',
        notify     => Exec["unlock $name"],
        require    => Group[$title],
    }

    # set password to * to unlock the account but forbid login through login
    exec { "unlock $name":
        command     => "usermod -p '*' $name",
        refreshonly => true,
    }

    file { $homedir:
        ensure  => directory,
        owner   => $name,
        group   => $name,
        require => User[$name],
    }

    file { "$homedir/.ssh":
        ensure  => directory,
        mode    => '0600',
        owner   => $name,
        group   => $name,
        require => File[$homedir],
    }
}
