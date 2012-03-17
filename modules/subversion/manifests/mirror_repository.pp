define subversion::mirror_repository( $source,
                                      $refresh = '*/5') {
    include subversion::mirror

    exec { "/usr/local/bin/create_svn_mirror.sh $name $source":
        creates => $name,
        require => Package['subversion-tools']
    }

    cron { "update $name":
        command => "/usr/bin/svnsync synchronize -q file://$name",
        minute  => $refresh,
        require => Exec["/usr/local/bin/create_svn_mirror.sh $name $source"],
    }
}
