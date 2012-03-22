class git {
    define svn_repository($source,
                          $std_layout = true,
                          $refresh = '*/5') {
        include git::svn
        include git::server
        # a cron job
        # a exec
        if $std_layout {
            $options = '-s'
        } else {
            $options =  ''
        }

        exec { "/usr/bin/git svn init $options $source $name":
            alias   => "git svn $name",
            creates => $name,
        }

        file { '/usr/local/bin/update_git_svn.sh':
            mode   => '0755',
            source => 'puppet:///modules/git/update_git_svn.sh',
        }

        cron { "update $name":
            # done in 2 times, so fetch can fill the repo after init
            command => "/usr/local/bin/update_git_svn.sh $name" ,
            minute  => $refresh
        }

        file { "$name/.git/hooks/pre-receive":
            mode    => '0755',
            content => template('git/pre-receive'),
            require => Exec["git svn $name"]
        }
    }

}
