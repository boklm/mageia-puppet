class ii {
    class base {
        package { ["ii", "perl-Proc-Daemon"]: }

        file { "/var/lib/ii/":
            ensure => directory,
            owner => nobody,
        }
    }

    define bot($server = 'irc.freenode.net',
               $channel) {

        $nick = $name

        include ii::base
        # a custom wrappper is needed since ii do not fork in the
        # background, and bash is not able to properly do it
        local_script { "ii_$nick":
            content => "ii/ii_wrapper.pl",
            require => Class['ii::base'],
        }

        service { 'ii':
            provider => base,
            start => "/usr/local/bin/ii_$nick",
            notify => Exec["join channel $nick"],
            require => Local_script["ii_$nick"],
        }

        exec { "join channel $nick":
            command => "echo '/j $channel' > /var/lib/ii/$nick/$server/in",
            user => nobody,
            refreshonly => true,
        }
    }
}
