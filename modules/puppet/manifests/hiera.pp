class puppet::hiera {
    package { ['ruby-hiera','ruby-hiera-puppet']: }

    # ugly, remove once hiera is either fixed or integrated to puppet
    file { '/etc/puppet/external/hiera':
        ensure  => link,
        target  => '/usr/lib/ruby/gems/1.8/gems/hiera-puppet-0.3.0/',
        require => Package['ruby-hiera-puppet'],
    }

    # ease the use fo the command line tool
    # who use a different location for the config file
    file { '/etc/hiera.yaml':
        ensure => link,
        target => '/etc/puppet/hiera.yaml',
    }

    file { '/etc/puppet/hiera.yaml':
        content => template('puppet/hiera.yaml'),
    }
}
