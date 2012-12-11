# should be replaced by vcsrepo
# https://github.com/reductivelabs/puppet-vcsrepo
# but not integrated in puppet directly for the moment
class subversion {
    class server {
        include subversion::tools

        package { 'subversion-server': }

        $svn_base_path = '/svn/'

        xinetd::service { 'svnserve':
            content => template('subversion/xinetd')
        }

        file { $svn_base_path:
            ensure => directory,
        }

        package { ['perl-SVN-Notify-Config', 'perl-SVN-Notify-Mirror']: }

        $local_dir = '/usr/local/share/subversion/'
        $local_dirs = ["$local_dir/pre-commit.d", "$local_dir/post-commit.d"]
        file { [$local_dir,$local_dirs]:
            ensure => directory,
        }

        # workaround the lack of umask command in puppet < 2.7
        mga-common::local_script { 'create_svn_repo.sh':
            content => template('subversion/create_svn_repo.sh')
        }

        file { "$local_dir/pre-commit.d/no_binary":
            mode    => '0755',
            content => template('subversion/no_binary')
        }

        file { "$local_dir/pre-commit.d/no_root_commit":
            mode    => '0755',
            content => template('subversion/no_root_commit')
        }

        file { "$local_dir/pre-commit.d/no_empty_message":
            mode    => '0755',
            content => template('subversion/no_empty_message')
        }

        file { "$local_dir/pre-commit.d/single_word_commit":
            mode    => '0755',
            content => template('subversion/single_word_commit')
        }

        file { "$local_dir/pre-revprop-change":
            mode    => '0755',
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
            file { "${subversion::server::local_dir}/pre-commit.d/$name":
                mode    => '0755',
                content => template('subversion/syntax_check.sh')
            }
        }


        syntax_check{'check_perl':
            regexp_ext => '\.p[lm]$',
            check_cmd  => 'perl -c'
        }

        syntax_check{'check_puppet':
            regexp_ext => '\.pp$',
            check_cmd  => 'puppet parser validate -'
        }

        syntax_check{'check_ruby':
            regexp_ext => '\.rb$',
            check_cmd  => 'ruby -c'
        }

        syntax_check{'check_puppet_templates':
            regexp_ext => 'modules/.*/templates/.*$',
            check_cmd  => 'erb -P -x -T - | ruby -c'
        }

        syntax_check{'check_po':
            regexp_ext => '\.po$',
            check_cmd  => 'msgfmt -c -'
        }

        syntax_check{'check_php':
            regexp_ext => '\.php$',
            check_cmd  => 'php -d display_errors=1 -d error_reporting="E_ALL|E_STRICT" -l'
        }

        # needed for check_php
        package { 'php-cli': }
    }
    # TODO
    #   deploy a cronjob to make a backup file ( ie, dump in some directory )
}
