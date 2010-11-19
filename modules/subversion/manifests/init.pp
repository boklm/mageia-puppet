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
       
        $local_dir = "/usr/local/share/subversion/"
        $local_dirs = ["$local_dir/pre-commit.d", "$local_dir/post-commit.d"] 
        file { $local_dir:
            ensure => directory,
        }
        # mettre tout les scripts dans le repertoire

    }

    # TODO create proper hook directory ( see zarb.org )
    # create documentation
    # - group who can commit 
    # - array for who get mail on what ( hash )
    # - array of where the directory is updated

    # later, deploy a backup file ( ie, cron job to do a dump in some directory )
    # TODO 
    # what about pre commit ?
    # - name of a template file ?
    # - prepare a template for file checking ?
    #   - openldap
    #   - named
    #   - puppet
    #   - perl/ php syntax

    
    define repository ($group = "svn",
                       $public = true,
                       $commit_mail = [],
                       $syntax_check = [],
                       $extract_dir = []) {
        # faire un script qui mets les permissions comme il faut
        # http://svnbook.red-bean.com/nightly/fr/svn.serverconfig.multimethod.html
        # $name ==> lieu du checkout

        # TODO set umask -> requires puppet 2.7.0
        exec { "svnadmin create $name":
            user => root,
            group => $group,
            creates => $name
        }
#        # TODO complete documentation
#
        file { "$name":
            group => $group,
            user => root,
            mode => $public ? {
                        true => 644,
                        false => 640
                    },
            ensure => directory
        }

        $hooks = ["$name/hooks/pre-commit","$name/hooks/post-commit"]
        file { "$hooks":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("subversion/hook_commit.sh")
        }

        $hooks_dir = ["$name/hooks/pre-commit.d","$name/hooks/post-commit.d"]
        file { "$hooks_dir":
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
        }

        if $commit_mail {
            file { "$name/hooks/post-commit.d/send_mail":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template("subversion/hook_sendmail.pl")
            }
        }  
    
    }   


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

        include subversion::client

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
