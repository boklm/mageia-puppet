class postgresql::server {
    $pgsql_data = '/var/lib/pgsql/data/'
    $pg_version = '9.0'

    # missing requires is corrected in cooker,
    # should be removed
    # once the fix is in a stable release
    package { "postgresql${pg_version}-plpgsql":
        alias => 'postgresql-plpgsql',
    }

    package { "postgresql${pg_version}-server":
        alias   => 'postgresql-server',
        require => Package['postgresql-plpgsql'],
    }

    service { 'postgresql':
        subscribe => Package['postgresql-server'],
    }

    exec { 'service postgresql reload':
        refreshonly => true,
    }

    openssl::self_signed_splitted_cert { "pgsql.$::domain":
        filename  => 'server',
        directory => $pgsql_data,
        owner     => 'postgres',
        group     => 'postgres',
        require   => Package['postgresql-server']
    }


    file { '/etc/pam.d/postgresql':
        content => template('postgresql/pam'),
    }

    $db = list_exported_ressources('Postgresql::Db_and_user')

    $forum_lang = list_exported_ressources('Phpbb::Locale_db')

    postgresql::config {
        "$pgsql_data/pg_hba.conf":
            content => template('postgresql/pg_hba.conf');
        "$pgsql_data/pg_ident.conf":
            content => template('postgresql/pg_ident.conf');
        "$pgsql_data/postgresql.conf":
            content => template('postgresql/postgresql.conf');
    }
}
