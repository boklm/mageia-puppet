define phpbb::config($key, $value, $database) {
    exec { "phpbb_apply $name":
        command     => "/usr/local/bin/phpbb_apply_config.pl $key",
        user        => 'root',
        environment => ["PGDATABASE=$database",
                        "PGUSER=$phpbb::base::user",
                        "PGPASSWORD=$phpbb::base::pgsql_password",
                        "PGHOST=pgsql.$::domain",
                        "VALUE=$value"],
        require     => File['/usr/local/bin/phpbb_apply_config.pl'],
    }
}
