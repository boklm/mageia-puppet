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

    class client inherits common {


    }

    class svn inherits client {
        package { 'git-svn': }
    }

    define snapshot($source, $refresh ='*/5', $user = 'root') {
        include git::client
        #TODO
        # should handle branch -> clone -n + branch + checkout
        # create a script
        # Idealy, should be handled by vcsrepo https://github.com/bruce/puppet-vcsrepo
        # once it is merged in puppet
        exec { "/usr/bin/git clone $source $name":
            creates => $name,
            user    => $user
        }

        cron { "update $name":
            # FIXME no -q ?
            command => "cd $name && /usr/bin/git pull",
            user    => $user,
            minute  => $refresh
        }
    }
}
