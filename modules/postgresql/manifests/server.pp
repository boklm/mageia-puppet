class postgresql::server {
    include postgresql::var

    # missing requires is corrected in cooker,
    # should be removed
    # once the fix is in a stable release
    package { "postgresql${postgresql::var::pg_version}-plpgsql":
        alias => 'postgresql-plpgsql',
    }

    package { "postgresql${postgresql::var::pg_version}-server":
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
        directory => $postgresql::var::pgsql_data,
        owner     => 'postgres',
        group     => 'postgres',
        require   => Package['postgresql-server']
    }


    file { '/etc/pam.d/postgresql':
        content => template('postgresql/pam'),
    }

    @postgresql::pg_hba { $postgresql::var::hba_file: }

    postgresql::hba_entry { 'allow_local_ipv4':
        type => 'host',
        database => 'all',
        user => 'all',
        address => '127.0.0.1/32',
        method => 'md5',
    }

    postgresql::config {
        "${postgresql::var::pgsql_data}/pg_ident.conf":
            content => template('postgresql/pg_ident.conf');
        "${postgresql::var::pgsql_data}/postgresql.conf":
            content => template('postgresql/postgresql.conf');
    }
}
