define subversion::snapshot($source,
                            $refresh = '*/5',
                            $user = 'root')  {

    include subversion::client

    exec { "/usr/bin/svn co $source $name":
        creates => $name,
        user    => $user,
        require => Package['subversion'],
    }

    if ($refresh != '0') {
        cron { "update $name":
            command => "cd $name && /usr/bin/svn update -q",
            user    => $user,
            minute  => $refresh,
            require => Exec["/usr/bin/svn co $source $name"],
        }
    }
}
