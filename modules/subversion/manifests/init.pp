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

        define syntax_check($regexp_ext,$check_cmd) {
            file { "$local_dir/pre-commit.d/$name":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('subversion/syntax_check.sh') 
            }
        }

        # mettre tout les scripts dans le repertoire
        file { "$local_dir/pre-commit.d/no_root_commit":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template('subversion/no_root_commit') 
        }

        file { "$local_dir/pre-commit.d/no_empty_message":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template('subversion/no_empty_message') 
        }

        # TODO : add check for
        #    - ym       perl -MYAML -e 'YAML::LoadFile("-");'
        #    - tt       ( do not seem to be possible, but this would be great )
        #    - php      php -l
        #    - python
        #    - named    named-checkzone/named-checkconf ( may requires some interaction with facter/erb )
        #    - po       msgfmt -c
        #    - openldap , like named

        syntax_check{"check_perl":
            regexp_ext => ".p[lm]$",
            check_cmd => "perl -c"
        }
    }

    # TODO 
    #   deploy a cronjob to make a backup file ( ie, dump in some directory )

    
    define repository ($group = "svn",
                       $public = true,
                       $commit_mail = [],
                       $syntax_check = [],
                       $extract_dir = []) {
        # check permissions
        # http://svnbook.red-bean.com/nightly/fr/svn.serverconfig.multimethod.html
        # $name ==> directory of the repo

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

        if $extract_dir {
            file { "$name/hooks/post-commit.d/extract_dir":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template("subversion/hook_extract.pl")
            }
        }

        $pre_commit_check = ['no_commit_log','no_root']
        $pre_commit_check += $syntax_check

        file { "$name/hooks/pre-commit.d/$pre_commit_check":
            ensure => "/usr/local/share/subversion/pre-commit.d/$pre_commit_check",
            owner => root,
            group => root,
            mode => 755
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
	$sasl2_package = $architecture ? {
        	x86_64 => "lib64sasl2-plug-anonymous",
        	default => "libsasl2-plug-anonymous"
    	}
 	
        package {"$sasl2_package":
            ensure => "installed"
        }
    }

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
