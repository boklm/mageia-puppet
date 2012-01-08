class xymon {
    class client {
        package { xymon-client: }

        service { xymon-client:
            ensure => running,
            path => '/etc/init.d/xymon-client',
            require => Package['xymon-client'],
        }

        # TODO replace with a exported ressource
        $server = extlookup('hobbit_server','x')
        file { '/etc/sysconfig/xymon-client':
            content => template("xymon/xymon-client"),
        }
    }

    class server {
        package { ["xymon","fping"]: }

        service { xymon:
                ensure => running,
                path => '/etc/init.d/xymon',
        }

        File {
            group => xymon,
            require => Package["xymon"],
            notify => Exec["service xymon reload"],
        }

        file {
            # Environment variables user by hobbitd,hobbitlaunch,hobbitd_rrd,CGIs
            # and bbgen (which generates the static html pages)
            # hobbitlaunch (started by init script) may need to be restarted for
            # changes here, for hobbitd_rrd (e.g. TEST2RRD), it is sufficient to
            # kill hobbitd_rrd, hobbitlaunch will respawn it
            '/etc/xymon/hobbitserver.cfg': content => template("xymon/hobbitserver.cfg");

            # Define hosts and web view layout, and lists tests to be run against
            # host by e.g. network tests from xymon server
            '/etc/xymon/bb-hosts': content => template("xymon/bb-hosts");

            # Defines thresholds for test data reported by clients, e.g. load
            # disk, procs, ports, memory, as well as those which require some
            # configuration server side to the client: files, msgs, 
            '/etc/xymon/hobbit-clients.cfg': content => template("xymon/hobbit-clients.cfg");

            # Configuration for the xymon clients, which log files to process etc.
            '/etc/xymon/client-local.cfg': content => template("xymon/client-local.cfg");

            # Used for alerting, changes should be taken into effect immediately
            '/etc/xymon/hobbit-alerts.cfg': content => template("xymon/hobbit-alerts.cfg");
        }

        # Most changes should take effect immediately, but sometimes threshold
        # changes take effect sooner if hobbit is HUPd
        exec { "service xymon reload":
            refreshonly => true,
            require => Package["xymon"],
        }
    }
}
