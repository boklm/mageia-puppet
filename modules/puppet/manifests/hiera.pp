class puppet::hiera {
    package { ['ruby-hiera','ruby-hiera-puppet']: }

    # ugly, remove once hiera is either fixed or integrated to puppet
    file { '/etc/puppet/external/hiera':
        ensure  => '/usr/lib/ruby/gems/1.8/gems/hiera-puppet-0.3.0/',
        require => Package['ruby-hiera-puppet'],
    }
}
