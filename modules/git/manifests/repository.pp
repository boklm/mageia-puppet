define git::repository($group,
                      $description = '') {

    include git::server
    # http://eagleas.livejournal.com/18907.html
    # TODO group permission should be handled here too
    exec { "/usr/local/bin/create_git_repo.sh $name":
        user    => 'root',
        group   => $group,
        creates => $name,
    }

    file { "$name/git-daemon-export-ok":
        require => Exec["/usr/local/bin/create_git_repo.sh $name"]
    }

    file { "$name/description":
        content => $description,
        require => File["$name/git-daemon-export-ok"]
    }

    file { "$name/hooks/post-receive":
        mode    => '0755',
        content => template('git/post-receive'),
        require => File["$name/git-daemon-export-ok"]
    }

    file { "$name/config.puppet":
        require => File["$name/git-daemon-export-ok"],
        notify  => Exec["/usr/local/bin/apply_git_puppet_config.sh $name"],
        content => template('git/config.puppet'),
    }

    # $name is not really used, but this prevent duplicate declaration error
    exec { "/usr/local/bin/apply_git_puppet_config.sh $name":
        cwd         => $name,
        user        => 'root',
        refreshonly => true,
    }
}
