# documentation :
#    group : group that have commit access on the svn
#    public : boolean if the svn is readable by anybody or not
#    commit_mail : array of people who will receive mail after each commit
#    irker_conf : hash containing irker config values. See man irkerhook
#                 for possible values in irker.conf.
#    irkerhook_path : path to irkerhook.py script
#    no_binary : do not accept files with common binary extensions 
#                on this repository
#    restricted_to_user : restrict commits to select user
#    syntax_check : array of pre-commit script with syntax check to add
#    extract_dir : hash of directory to update upon commit ( with svn update ),
#            initial checkout is not handled, nor the permission
#            TODO, handle the tags ( see svn::notify::mirror )

define subversion::repository($group = 'svn',
                              $public = true,
                              $commit_mail = '',
                              $irker_conf = undef,
                              $irkerhook_path = '/usr/lib/irker/irkerhook.py',
                              $i18n_mail = '',
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
        user    => 'root',
        group   => $group,
        creates => "$name/hooks",
        require => Package['subversion-tools'],
    }

    file { $name:
        group  => $group,
        owner  => 'root',
        mode   => $public ? {
            true  => 644,
            false => 640,
            },
        ensure => directory
    }

    file { ["$name/hooks/pre-commit","$name/hooks/post-commit"]:
        mode    => '0755',
        content => template('subversion/hook_commit.sh'),
        require => Exec["/usr/local/bin/create_svn_repo.sh $name"],
    }

    file { ["$name/hooks/post-commit.d", "$name/hooks/pre-commit.d"]:
        ensure  => directory,
        require => File["$name/hooks/pre-commit"],
    }

    file { "$name/hooks/pre-revprop-change":
        ensure  => "$subversion::server::local_dir/pre-revprop-change",
        mode    => '0755',
        require => File["$name/hooks/pre-commit"],
    }

    if $restricted_to_user {
        subversion::hook::pre_commit { "$name|restricted_to_user":
            content => template('subversion/restricted_to_user'),
        }
    } else {
        file { "$name/hooks/pre-commit.d/restricted_to_user":
            ensure => absent,
        }
    }

    if $commit_mail {
        subversion::hook::post_commit { "$name|send_mail":
            content => template('subversion/hook_sendmail.pl'),
            require => Package['perl-SVN-Notify-Config'],
        }
    } else {
        file { "$name/hooks/post-commit.d/send_mail":
            ensure => absent,
        }
    }


    if $irker_conf {
        subversion::hook::post_commit { "$name|irker":
            content => template('subversion/hook_irker'),
        }
        file { "$name/irker.conf":
            content => template('subversion/irker.conf'),
        }
    } else {
        file { "$name/hooks/post-commit.d/irker":
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
                content => template('subversion/hook_extract.pl'),
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


