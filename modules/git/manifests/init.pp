class git {
    class common {
        package { 'git-core':
        }
    }

    class server inherits common {
        # http://www.kernel.org/pub/software/scm/git/docs/everyday.html#Repository%20Administration
        $git_base_path = '/git/'

        xinetd::service { "git":
            content => template('git/xinetd')
        }

        file { "$git_base_path":
            ensure => directory
        }

        # TODO
        # define common syntax check, see svn 
        #          http://stackoverflow.com/questions/3719883/git-hook-syntax-check
        #        proper policy : fast-forward-only 
        #              ( http://progit.org/book/ch7-4.html ) 
        #            no branch ?
        #            no binary
        #            no big file
        #            no empty commit message
        #            no commit from root
        #        see http://www.itk.org/Wiki/Git/Hooks 
        #        automated push to another git repo ( see http://noone.org/blog/English/Computer/VCS/Thoughts%20on%20Gitorious%20and%20GitHub%20plus%20a%20useful%20git%20hook.futile
        # 
        # how do we handle commit permission ?
        #   mail sending
        # 
    }

    define repository($description = '') {
        # http://eagleas.livejournal.com/18907.html
        # TODO --shared=group + set g+ws 
        exec { "git init --bare $name":
            creates => $name,
        }

        file { "$name/git-daemon-export-ok":
            ensure => present,
            requires => Exec["git init --bare $name"]
        }
        
        file { "$name/description":
            ensure => present,
            content => $description
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



