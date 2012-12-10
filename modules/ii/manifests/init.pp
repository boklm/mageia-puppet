class ii {
    class base {
        package {['ii',
                  'perl-Proc-Daemon']: }

        file { '/var/lib/ii/':
            ensure => directory,
            owner  => 'nobody',
        }
    }

    define bot( $server = 'irc.freenode.net',
                $channel) {

        $nick = $name

        include ii::base
        # a custom wrappper is needed since ii do not fork in the
        # background, and bash is not able to properly do it
        mga-common::local_script { "ii_$nick":
            content => template('ii/ii_wrapper.pl'),
            require => Class['ii::base'],
        }

        service { 'ii':
            provider => base,
            start    => "/usr/local/bin/ii_$nick",
            require  => Mga-common::Local_script["ii_$nick"],
        }

        exec { "join channel $nick":
            command => "echo '/j $channel' > /var/lib/ii/$nick/$server/in",
            user    => 'nobody',
            creates => "/var/lib/ii/$nick/$server/$channel/in",
            require => Service['ii'],
        }
    }
}
