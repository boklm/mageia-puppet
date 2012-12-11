class buildsystem::youri_submit {
    include sudo
    include buildsystem::rpmlint
    include buildsystem::repository
    include buildsystem::var::scheduler

    $repository_root = $buildsystem::repository::dir
    $sched_home_dir = $buildsystem::var::scheduler::homedir
    $sched_login = $buildsystem::var::scheduler::login
    $packages_archivedir = "$sched_home_dir/old"

    mga-common::local_script {
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
        '/etc/youri/submit-todo.conf':
            content => template('buildsystem/youri/submit-todo.conf');
        '/etc/youri/submit-upload.conf':
            content => template('buildsystem/youri/submit-upload.conf');
        '/etc/youri/acl.conf':
            content => template('buildsystem/youri/acl.conf');
    }

    file { $packages_archivedir:
        ensure  => 'directory',
        owner   => $sched_login,
        require => File[$sched_home_dir],
    }

    tidy { $packages_archivedir:
        type    => 'ctime',
        recurse => true,
        age     => '1w',
        matches => '*.rpm',
    }

    include mga-common::var::perl
    file { [ "${mga-common::var::perl::site_perl_dir}/Youri",
             "${mga-common::var::perl::site_perl_dir}/Youri/Repository"]:
        ensure => directory,
        mode => 0755,
        owner => root,
        group => root,
    }
    file { "${mga-common::var::perl::site_perl_dir}/Youri/Repository/Mageia.pm":
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
