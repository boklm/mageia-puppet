# should be replaced by vcsrepo
# https://github.com/reductivelabs/puppet-vcsrepo
# but not integrated in puppet directly for the moment
class subversion {


    class server {
        package { ["subversion-server", "subversion-tools"]:
            ensure => installed,
        }

        package { "perl-SVN-Notify-Config":
            ensure => installed,
        }
       
        $local_dir = "/usr/local/share/subversion/"
        $local_dirs = ["$local_dir/pre-commit.d", "$local_dir/post-commit.d"] 
        file { [$local_dir,$local_dirs]:
             owner => root,
             group => root,
             mode => 755,
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
            regexp_ext => "\.p[lm]$",
            check_cmd => "perl -c"
        }

        syntax_check{"check_puppet":
            regexp_ext => "\.pp$",
            check_cmd => "puppet --color=false --confdir=/tmp --vardir=/tmp --parseonly"
        }

        syntax_check{"check_ruby":
            regexp_ext => "\.rb$",
            check_cmd => "ruby -c"
        }

        syntax_check{"check_puppet_templates":
            regexp_ext => "modules/.*/templates/.*$",
            check_cmd => "erb -x -T - | ruby -c"
        }
    }

   
    # FIXME ugly
    define pre_commit_link($directory) {
	file { "pre_commit_link-${name}":
	    path => "$directory/$name",
	    ensure => "/usr/local/share/subversion/pre-commit.d/$name",
	    owner => root,
	    group => root,
	    mode => 755,
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
	include subversion::server
        # TODO set umask -> requires puppet 2.7.0
        exec { "svnadmin create $name":
            user => root,
            group => $group,
            creates => "$name/hooks",
	    require => Package['subversion-tools'],
        }
#        # TODO complete documentation
#
        file { "$name":
            group => $group,
            owner => root,
            mode => $public ? {
                        true => 644,
                        false => 640
                    },
            ensure => directory
        }

        file { ["$name/hooks/pre-commit","$name/hooks/post-commit"]:
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template("subversion/hook_commit.sh"),
	    require => Exec["svnadmin create $name"],
        }

        file { ["$name/hooks/post-commit.d", "$name/hooks/pre-commit.d"]:
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
	    require => Exec["svnadmin create $name"],
        }

        if $commit_mail {
            file { "$name/hooks/post-commit.d/send_mail":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template("subversion/hook_sendmail.pl"),
	    	require => [Exec["svnadmin create $name"], Package['perl-SVN-Notify-Config']],
            }
        }

        if $extract_dir {
            file { "$name/hooks/post-commit.d/extract_dir":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template("subversion/hook_extract.pl"),
	    	require => Exec["svnadmin create $name"],
            }
        }


	pre_commit_link { ['no_empty_message','no_root_commit', $syntax_check]: 
		directory => "$name/hooks/pre-commit.d/"
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
