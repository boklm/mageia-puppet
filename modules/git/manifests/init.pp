class git {
    class common {
        package { 'git-core':
        }
    }

    class server inherits common {
        $git_base_path = '/git/'

        xinetd::service { "git":
            content => template('git/xinetd')
        }

        file { "$git_base_path":
            ensure => directory
        }

        # TODO
        # define common syntax check, see svn 
        #        proper policy : no-fast-forward
        #            no branch ?
        #            no binary
        #            no big file
        #            no empty commit message, no root 
        #        automated push to another git repo ( see http://noone.org/blog/English/Computer/VCS/Thoughts%20on%20Gitorious%20and%20GitHub%20plus%20a%20useful%20git%20hook.futile
        # 
        # how do we handle commit permission ?
    }

    define repository {
        exec { "git init --bare $name":
            creates => $name,
        }

    }

    class client inherits common {


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
            user => $user
        }
        
        cron { "update $name":
            # FIXME no -q ?
            command => "cd $name && /usr/bin/git pull",
            user => $user,
            minute => $refresh
        }
    }
}



