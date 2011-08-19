class testvm
{
    $testvm_login = "testvm"
    $testvmdir = "/home/testvm"

    group {"$testvm_login":
	ensure => present,
    }

    user {"$testvm_login":
	ensure => present,
	comment => "System user used to run test VMs",
	managehome => true,
	gid => $vmtest_login,
	shell => "/bin/bash",
    }
    
    file { "$testvmdir/bin/":
        ensure => directory,
        require => User[$testvm_login],
    }

    file { "$testvmdir/bin/_vm":
	ensure => present,
        owner => root,
	group => root,
	mode => 644,
	source => "puppet:///modules/testvm/_vm",
        require => File["$testvmdir/bin"],
    }

    file { "$testvmdir/bin/vm-jonund":
	ensure => present,
        owner => root,
	group => $testvm_login,
	mode => 750,
	source => "puppet:///modules/testvm/vm-jonund",
        require => File["$testvmdir/bin"],
    }
}
