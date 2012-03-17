define catdap::snapshot($location, $svn_location) {
    file { "$location/catdap_local.yml":
        group   => apache,
        mode    => '0640',
        content => template('catdap/catdap_local.yml'),
        require => Subversion::Snapshot[$location],
    }

    subversion::snapshot { $location:
        source => $svn_location
    }

    apache::vhost_catalyst_app { $name:
        script   => "$location/script/catdap_fastcgi.pl",
        location => $location,
        use_ssl  => true,
    }

    apache::vhost_redirect_ssl { $name: }
}
