class xymon {

    class client {
	package { xymon-client:
	    ensure => installed,
	}
	service { xymon-client:
	    ensure => running,
	    path => '/etc/init.d/xymon-client',
	}
	file { '/etc/sysconfig/xymon-client':
	    content => template("xymon/xymon-client"),
	}
    }

    class server {
	package { xymon:
	    ensure => installed,
	}
	service { xymon:
	    ensure => running,
	    path => '/etc/init.d/xymon',
	}
	# Environment variables user by hobbitd,hobbitlaunch,hobbitd_rrd,CGIs
	# and bbgen (which generates the static html pages)
	# hobbitlaunch (started by init script) may need to be restarted for
	# changes here, for hobbitd_rrd (e.g. TEST2RRD), it is sufficient to
	# kill hobbitd_rrd, hobbitlaunch will respawn it
	file { '/etc/xymon/hobbitserver.cfg':
	    ensure => present,
	    user => root,
	    group => xymon,
	    mode => 644,
	    require => Package["xymon"],
	    notify => Service["xymon"],
	    content => template("xymon/hobbitserver.cfg"),
	}
	# Define hosts and web view layout, and lists tests to be run against
	# host by e.g. network tests from xymon server
	file {'/etc/xymon/bb-hosts':
	    ensure => present,
	    user => root,
	    group => xymon,
	    mode => 644,
	    content => template("xymon/bb-hosts"),
	}

	# Defines thresholds for test data reported by clients, e.g. load
	# disk, procs, ports, memory, as well as those which require some
	# configuration server side to the client: files, msgs, 
	file { 'hobbit-clients.cfg':
	    path => '/etc/xymon/hobbit-clients.cfg',
	    ensure => present,
	    user => root,
	    group => xymon,
	    mode => 644,
	    content => template("xymon/hobbit-clients.cfg"),
	}
	# Configuration for the xymon clients, which log files to process etc.
	file {'client-local.cfg':
	    path => '/etc/xymon/client-local.cfg',
	    ensure => present,
	    user => root,
	    group => xymon,
	    mode => 644,
	    content => template("xymon/client-local.cfg"),
	}

	# Used for alerting, changes should be taken into effect immediately
	file {'hobbit-alerts.cfg':
	    path => '/etc/xymon/hobbit-alerts.cfg',
	    ensure => present,
	    user => root,
	    group => xymon,
	    mode => 644,
	    content => template("xymon/hobbit-alerts.cfg"),
	}
	# Most changes should take effect immediately, but sometimes threshold
	# changes take effect sooner if hobbit is HUPd
	exec { "service xymon reload":
            refreshonly => true,
            subscribe => [ 
		File["hobbit-clients.cfg"],
		File["hobbit-alerts.cfg"],
		File["client-local.cfg"],
	    ]
        }
    }
}
