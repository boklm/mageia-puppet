# should be replaced by vcsrepo
# https://github.com/reductivelabs/puppet-vcsrepo
# but not integrated in puppet directly for the moment
class subversion {


    class server {
        package { ["subversion-server", "subversion-tools"]:
            ensure => installed,
        }

        package { ["perl-SVN-Notify-Config", "perl-SVN-Notify-Mirror"]:
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

 	# workaround the lack of umask command in puppet < 2.7
	file { "/usr/local/bin/create_svn_repo.sh":
             ensure => present,
             owner => root,
             group => root,
             mode => 755,
             content => template('subversion/create_svn_repo.sh') 
	} 

        file { "$local_dir/pre-commit.d/no_binary":
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            content => template('subversion/no_binary') 
        }

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

        define syntax_check($regexp_ext,$check_cmd) {
            file { "$local_dir/pre-commit.d/$name":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template('subversion/syntax_check.sh') 
            }
        }


        syntax_check{"check_perl":
            regexp_ext => "\.p[lm]$",
            check_cmd => "perl -c"
        }

        syntax_check{"check_puppet":
            regexp_ext => "\.pp$",
            check_cmd => "puppet --color=false --confdir=/tmp --vardir=/tmp --parseonly --ignoreimport"
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
    define pre_commit_link($scriptname) {
	file { "${name}":
	    ensure => "/usr/local/share/subversion/pre-commit.d/$scriptname",
	    owner => root,
	    group => root,
	    mode => 755,
	}
    } 

    # TODO 
    #   deploy a cronjob to make a backup file ( ie, dump in some directory )

    # documentation :
    #    group : group that have commit access on the svn
    #    public : boolean if the svn is readable by anybody or not
    #    commit_mail : array of people who will receive mail after each commit
    #    syntax_check1 : pre-commit script with syntax check to add
    #    syntax_check2 : pre-commit script with syntax check to add
    #    syntax_check3 : pre-commit script with syntax check to add
    #    extract_dir : hash of directory to update upon commit ( with svn update ), 
    #            initial checkout is not handled, nor the permission
    #            TODO, handle the tags ( see svn::notify::mirror )

    define repository ($group = "svn",
                       $public = true,
                       $commit_mail = '',
                       $cia_post = true,
                       $cia_module = 'default',
		       $no_binary = false,
                       $syntax_check1 = '',
                       $syntax_check2 = '',
                       $syntax_check3 = '',
                       $extract_dir = '') {
        # check permissions
        # http://svnbook.red-bean.com/nightly/fr/svn.serverconfig.multimethod.html
        # $name ==> directory of the repo
	include subversion::server
        # TODO set umask -> requires puppet 2.7.0
	# unfortunatly, umask is required
	# http://projects.puppetlabs.com/issues/4424
        exec { "/usr/local/bin/create_svn_repo.sh $name":
            user => root,
            group => $group,
            creates => "$name/hooks",
	    require => Package['subversion-tools'],
        }
        
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
	    require => Exec["/usr/local/bin/create_svn_repo.sh $name"],
        }

        file { ["$name/hooks/post-commit.d", "$name/hooks/pre-commit.d"]:
            ensure => directory,
            owner => root,
            group => root,
            mode => 755,
	    require => File["$name/hooks/pre-commit"],
        }

        if $commit_mail {
            file { "$name/hooks/post-commit.d/send_mail":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template("subversion/hook_sendmail.pl"),
	    	require => [Package['perl-SVN-Notify-Config']],
            }
        }

	if $cia_post {
	    file { "$name/hooks/post-commit.d/cia.vc":
		ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template("subversion/ciabot_svn.sh"),
            }
		
	}

	if $no_binary {
	    pre_commit_link { '$name/hooks/pre-commit.d/no_binary': 
		scriptname => 'no_binary',
	    }
	}

        if $extract_dir {
            file { "$name/hooks/post-commit.d/extract_dir":
                ensure => present,
                owner => root,
                group => root,
                mode => 755,
                content => template("subversion/hook_extract.pl"),
	    	require => [Package['perl-SVN-Notify-Mirror']],
            }
        }

	pre_commit_link { "$name/hooks/post-commit.d/no_empty_message":
	    scriptname => 'no_empty_message',
	}
	pre_commit_link { "$name/hooks/post-commit.d/no_root_commit":
	    scriptname => 'no_root_commit',
	}
	if $syntax_check1 {
	    pre_commit_link { "$name/hooks/post-commit.d/${syntax_check1}":
	        scriptname => $syntax_check1,
	    }
	}
	if $syntax_check2 {
	    pre_commit_link { "$name/hooks/post-commit.d/${syntax_check2}":
		scriptname => $syntax_check2,
	    }
	}
	if $syntax_check3 {
	    pre_commit_link { "$name/hooks/post-commit.d/${syntax_check3}":
		scriptname => $syntax_check3,
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
