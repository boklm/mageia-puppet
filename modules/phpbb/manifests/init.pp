class phpbb {

    include apache::mod_php
    include mysql

    package { ["php-gd","php-xml","php-zlib","php-ftp","php-magickwand" ]
        ensure => installed
    }

    # TODO ldap account configuration

    # TODO apache setup

    # TODO git checkout 

    # TODO mysql vm creation

}
