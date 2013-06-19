class buildsystem::youri_submit {
    include sudo
    include buildsystem::rpmlint
    include buildsystem::repository
    include buildsystem::var::scheduler
    include buildsystem::var::youri

    mga_common::local_script {
        'mga-youri-submit':
            content => template('buildsystem/mga-youri-submit');
        'mga-youri-submit.wrapper':
            content => template('buildsystem/mga-youri-submit.wrapper');
        'submit_package':
            content => template('buildsystem/submit_package.pl');
        'mga-clean-distrib':
            content => template('buildsystem/cleaner.rb');
    }

    sudo::sudoers_config { 'mga-youri-submit':
        content => template('buildsystem/sudoers.youri')
    }
    # ordering is automatic :
    # http://docs.puppetlabs.com/learning/ordering.html#autorequire
    file {
        '/etc/youri/':
            ensure => 'directory';
        '/etc/youri/acl.conf':
            content => template('buildsystem/youri/acl.conf');
	'/etc/youri/host.conf':
	    content => template('buildsystem/youri/host.conf');
    }

    buildsystem::youri_submit_conf{ 'upload':
	tmpl_file => $buildsystem::var::youri::tmpl_youri_upload_conf,
    }
    buildsystem::youri_submit_conf{ 'todo':
    	tmpl_file => $buildsystem::var::youri::tmpl_youri_todo_conf,
    }

    file { $buildsystem::var::youri::packages_archivedir:
        ensure  => 'directory',
        owner   => $buildsystem::var::scheduler::login,
        require => File[$buildsystem::var::scheduler::homedir],
    }

    tidy { $buildsystem::var::youri::packages_archivedir:
        type    => 'ctime',
        recurse => true,
        age     => '1w',
        matches => '*.rpm',
    }

    include mga_common::var::perl
    file { [ "${mga_common::var::perl::site_perl_dir}/Youri",
             "${mga_common::var::perl::site_perl_dir}/Youri/Repository"]:
        ensure => directory,
        mode => 0755,
        owner => root,
        group => root,
    }
    file { "${mga_common::var::perl::site_perl_dir}/Youri/Repository/Mageia.pm":
        source => 'puppet:///modules/buildsystem/Mageia.pm',
    }

    $package_list= ['perl-SVN',
                    'mdv-distrib-tools',
                    'perl-Youri-Media',
                    'perl-Youri-Package',
                    'perl-Youri-Repository',
                    'perl-Youri-Utils',
                    'perl-Youri-Config',
                    'mga-youri-submit']

    package { $package_list: }
}
