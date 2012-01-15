class reports {
    class ii {
        $channel = "#mageia-sysadm"
        $server = "irc.freenode.net"
        # tribute to Masamune Shirow
        $nick = "project_2501"
        
        ii::bot { $nick:
            channel => $channel,
            server => $server,
        }

        file { "/etc/puppet/socket.yaml":
            content => template("reports/socket.yaml"),
        }
    }
}
