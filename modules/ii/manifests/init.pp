class ii {
    class base {
        package { "ii": }

        file { "/var/lib/ii/":
            ensure => directory,
            owner => nobody,
        }
    }

    define bot($server = 'irc.freenode.net',
               $channel) {

        $nick = $name

        include ii::base

        service { 'ii':
            provider => base,
            start => "su nobody -c 'ii -n $nick -i /var/lib/ii/$nick -s $server'",
            notify => "join channel",
        }

        exec { "join channel":
            command => "echo '/j $channel' > /var/lib/ii/$nick/$server/in",
            user => nobody,
            refreshonly => true,
        }
    }
}
