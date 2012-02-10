class repositories::sparkleshare {
    $sp_dir = '/git/sparkleshare'
    file { $sp_dir:
        ensure => directory,
    }

    git::repository { "$sp_dir/test":
        description => 'Test sparkleshare repository',
        group       => 'mga-packagers-committers',
    }
}
