define git::snapshot( $source,
                      $refresh = '*/5',
                      $user = 'root') {
    include git::client
    #TODO
    # should handle branch -> clone -n + branch + checkout
    # create a script
    # Idealy, should be handled by vcsrepo
    # https://github.com/bruce/puppet-vcsrepo
    # once it is merged in puppet
    exec { "/usr/bin/git clone $source $name":
        creates => $name,
        user    => $user
    }

    cron { "update $name":
        # FIXME no -q ?
        command => "cd $name && /usr/bin/git pull",
        user    => $user,
        minute  => $refresh
    }
}
