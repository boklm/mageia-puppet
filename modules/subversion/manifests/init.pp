# should be replaced by vcsrepo
# https://github.com/reductivelabs/puppet-vcsrepo
# but not integrated in puppet directly for the moment
class subversion {


    class server {
        package { "subversion-server":
            ensure => installed,
        }

        package { "perl-SVN-Notify-Config":
            ensure => installed,
        }

    }

    # TODO create proper hook directory ( see zarb.org )
    # create documentation
    # - group who can commit 

#    define repository ($group => "svn") {
#        # $name ==> lieu du checkout 
#        exec { "svnadmin create $name":
#            path => "/usr/bin:/usr/sbin:/bin",
#            creates => $name             
#        }
#        # TODO complete documentation
#        file { "$name":
#            mode => 660
#            recurse => true
#        } 
#        # file pour les hooks
#    }


    class client {
        package { subversion:
            ensure => installed,
        }
        # svn spam log with 
        # Oct 26 13:30:01 valstar svn: No worthy mechs found
        # without it, source http://mail-index.netbsd.org/pkgsrc-users/2008/11/23/msg008706.html 
        # 
        package {"lib64sasl2-plug-anonymous":
            ensure => "installed"
        }
    }

    # TODO ensure that subversion ishere
    #      allow to configure the snapshot refresh interval
    define snapshot($source, $refresh = '*/5', $user = 'root')  {
        exec { "/usr/bin/svn co $source $name":
            creates => $name,           
            user => $user,  
        }

        cron { "update $name":
           command => "cd $name && /usr/bin/svn update -q",
           user => $user,
           minute => $refresh
        }   
    }
}
