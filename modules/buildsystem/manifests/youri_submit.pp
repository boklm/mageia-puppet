class buildsystem::youri_submit {
    $sched_home_dir = $buildsystem::base::sched_home_dir
    $sched_login = $buildsystem::base::sched_login
    $packages_archivedir = "$sched_home_dir/old"

    include sudo

    local_script {
        'mga-youri-submit':
            content => template('buildsystem/mga-youri-submit');
        'mga-youri-submit.wrapper':
            content => template('buildsystem/mga-youri-submit.wrapper');
        'submit_package':
            content => template('buildsystem/submit_package.pl');
    }

    sudo::sudoers_config { 'mga-youri-submit':
        content => template('buildsystem/sudoers.youri')
    }

    package { 'rpmlint': }

    file { '/etc/rpmlint/config':
        require => Package['rpmlint'],
        content => template('buildsystem/rpmlint.conf')
    }

    # directory that hold configuration auto extracted after upload
    # of the rpmlint policy
    file { '/etc/rpmlint/extracted.d/':
        ensure  => directory,
        require => Package['rpmlint'],
        owner   => $sched_login,
    }

    # ordering is automatic :
    # http://docs.puppetlabs.com/learning/ordering.html#autorequire
    file { '/etc/youri':
        ensure => 'directory',
    }

    file {
        '/etc/youri/submit-todo.conf':
            content => template('buildsystem/submit-todo.conf');
        '/etc/youri/submit-upload.conf':
            content => template('buildsystem/submit-upload.conf');
        '/etc/youri/acl.conf':
            content => template('buildsystem/youri_acl.conf');
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

    # FIXME use /usr/local/ once it will be in @INC
    file { '/usr/lib/perl5/vendor_perl/5.12.3/Youri/Repository/Mageia.pm':
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
