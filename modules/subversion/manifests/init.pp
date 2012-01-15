# should be replaced by vcsrepo
# https://github.com/reductivelabs/puppet-vcsrepo
# but not integrated in puppet directly for the moment
class subversion {

    class tools {
        package { "subversion-tools": }
    }

    class server {
        include subversion::tools

        package { "subversion-server": }
        
        $svn_base_path = '/svn/'

        xinetd::service { "svnserve":
            content => template('subversion/xinetd')
        }

        file { "$svn_base_path":
            ensure => directory,
        }

        package { ["perl-SVN-Notify-Config", "perl-SVN-Notify-Mirror"]: }
       
        $local_dir = "/usr/local/share/subversion/"
        $local_dirs = ["$local_dir/pre-commit.d", "$local_dir/post-commit.d"] 
        file { [$local_dir,$local_dirs]:
             ensure => directory,
        }

        # workaround the lack of umask command in puppet < 2.7
        local_script { "create_svn_repo.sh":
             content => template('subversion/create_svn_repo.sh') 
        }

        file { "$local_dir/pre-commit.d/no_binary":
            mode => 755,
            content => template('subversion/no_binary') 
        }

        file { "$local_dir/pre-commit.d/no_root_commit":
            mode => 755,
            content => template('subversion/no_root_commit') 
        }

        file { "$local_dir/pre-commit.d/no_empty_message":
            mode => 755,
            content => template('subversion/no_empty_message') 
        }

        file { "$local_dir/pre-commit.d/single_word_commit":
            mode => 755,
            content => template('subversion/single_word_commit') 
        }

        file { "$local_dir/pre-revprop-change":
            mode => 755,
            content => template('subversion/pre-revprop-change') 
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
                mode => 755,
                content => template('subversion/syntax_check.sh') 
            }
        }


        syntax_check{"check_perl":
            regexp_ext => '\.p[lm]$',
            check_cmd => 'perl -c'
        }

        syntax_check{"check_puppet":
            regexp_ext => '\.pp$',
            check_cmd => 'puppet parser validate -'
        }

        syntax_check{"check_ruby":
            regexp_ext => '\.rb$',
            check_cmd => 'ruby -c'
        }

        syntax_check{"check_puppet_templates":
            regexp_ext => 'modules/.*/templates/.*$',
            check_cmd => 'erb -P -x -T - | ruby -c'
        }

        syntax_check{"check_po":
            regexp_ext => '\.po$',
            check_cmd => 'msgfmt -c -'
        }

        syntax_check{"check_php":
            regexp_ext => '\.php$',
            check_cmd => 'php -d display_errors=1 -d error_reporting="E_ALL|E_STRICT" -l'
        }

	# needed for check_php
        package { "php-cli": }

    }

   
    define pre_commit_link() {
        $scriptname = regsubst($name,'^.*/', '')
        file { "${name}":
            ensure => "/usr/local/share/subversion/pre-commit.d/$scriptname",
            mode => 755,
        }
    } 

    # TODO 
    #   deploy a cronjob to make a backup file ( ie, dump in some directory )

    # documentation :
    #    group : group that have commit access on the svn
    #    public : boolean if the svn is readable by anybody or not
    #    commit_mail : array of people who will receive mail after each commit
    #    cia_post : send commits to cia.vc
    #    cia_module : name of the module to send to cia.vc
    #    cia_ignore_author : a regexp to ignore commits from some authors
    #    no_binary : do not accept files with common binary extentions on this repository
    #    restricted_to_user : restrict commits to select user
    #    syntax_check : array of pre-commit script with syntax check to add
    #    extract_dir : hash of directory to update upon commit ( with svn update ), 
    #            initial checkout is not handled, nor the permission
    #            TODO, handle the tags ( see svn::notify::mirror )

    define repository ($group = "svn",
                       $public = true,
                       $commit_mail = '',
                       $i18n_mail = '',
                       $cia_post = true,
                       $cia_module = 'default',
		       $cia_ignore_author = '',
		       $no_binary = false,
		       $restricted_to_user = false,
                       $syntax_check = '',
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
            mode => 755,
            content => template("subversion/hook_commit.sh"),
	    require => Exec["/usr/local/bin/create_svn_repo.sh $name"],
        }

        file { ["$name/hooks/post-commit.d", "$name/hooks/pre-commit.d"]:
            ensure => directory,
            require => File["$name/hooks/pre-commit"],
        }

        file { "$name/hooks/pre-revprop-change":
            ensure => "$subversion::server::local_dir/pre-revprop-change",
            mode => 755,
            require => File["$name/hooks/pre-commit"],
        } 

        if $restricted_to_user {
            subversion::hook::pre_commit { "$name|restricted_to_user":
                content => template("subversion/restricted_to_user"),
            }
        } else {
            file { "$name/hooks/pre-commit.d/restricted_to_user":
                ensure => absent,
            }
        }

        if $commit_mail {
            subversion::hook::post_commit { "$name|send_mail":
                content => template("subversion/hook_sendmail.pl"),
                require => [Package['perl-SVN-Notify-Config']],
            }
        } else {
            file { "$name/hooks/post-commit.d/send_mail":
	    	ensure => absent,
	    }
	}

	if $cia_post {
            subversion::hook::post_commit { "$name|cia.vc":
                content => template("subversion/ciabot_svn.sh"),
            }
		
	} else {
	    file { "$name/hooks/post-commit.d/cia.vc":
		ensure => absent,
	    }
	}

	if $no_binary {
	    pre_commit_link { "$name/hooks/pre-commit.d/no_binary": }
	} else {
	    file { "$name/hooks/pre-commit.d/no_binary":
	       ensure => absent,
	    }
	}

        if $extract_dir {
            subversion::hook::post_commit {"$name|extract_dir":
                content => template("subversion/hook_extract.pl"),
                require => [Package['perl-SVN-Notify-Mirror']],
            }
        } else {
            file { "$name/hooks/post-commit.d/extract_dir":
                ensure => absent,
            }
        }

	pre_commit_link { "$name/hooks/pre-commit.d/no_empty_message": } 

	pre_commit_link { "$name/hooks/pre-commit.d/no_root_commit": }

	if $syntax_check {
	    $syntax_check_array = regsubst($syntax_check,'^',"$name/hooks/pre-commit.d/")
	    pre_commit_link { $syntax_check_array: }
        }
    }


    class client {
        # svn spam log with 
        # Oct 26 13:30:01 valstar svn: No worthy mechs found
        # without it, source http://mail-index.netbsd.org/pkgsrc-users/2008/11/23/msg008706.html 
        #
        $sasl2_package = $architecture ? {
        	x86_64 => "lib64sasl2-plug-anonymous",
        	default => "libsasl2-plug-anonymous"
    	}
 	
        package {['subversion', "$sasl2_package"]: }
    }

    define snapshot($source, $refresh = '*/5', $user = 'root')  {

        include subversion::client

        exec { "/usr/bin/svn co $source $name":
            creates => $name,           
            user => $user,
            require => Package['subversion']
        }

        cron { "update $name":
           command => "cd $name && /usr/bin/svn update -q",
           user => $user,
           minute => $refresh,
           require => Exec["/usr/bin/svn co $source $name"],
        }   
    }
    
    class mirror { 
        include subversion::tools
        local_script { "create_svn_mirror.sh":
             content => template('subversion/create_svn_mirror.sh') 
        }
    }

    define mirror_repository($source,
                             $refresh = '*/5') {
        include subversion::mirror 

        exec { "/usr/local/bin/create_svn_mirror.sh $name $source":
            creates => $name,           
            require => Package['subversion-tools']
        }

        cron { "update $name":
           command => "/usr/bin/svnsync synchronize -q file://$name",
           minute => $refresh,
           require => Exec["/usr/local/bin/create_svn_mirror.sh $name $source"],
        }   
    } 
}
