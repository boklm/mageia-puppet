class bugzilla {

    $bugzilla_location = '/usr/share/bugzilla/template/en/custom'

    package {['bugzilla',
              'graphviz',
              'perl-Template-GD', # needed for graphical_report support
              'perl-Test-Taint',
              'perl-JSON-RPC']: }

    $pgsql_password = extlookup('bugzilla_pgsql','x')
    $ldap_password = extlookup('bugzilla_ldap','x')

    postgresql::remote_db_and_user { 'bugs':
        description => 'Bugzilla database',
        password    => $pgsql_password,
    }

    file { '/etc/bugzilla/localconfig':
      group   => 'apache',
      mode    => '0640',
      content => template('bugzilla/localconfig'),
      require => Package['bugzilla'],
    }


    file { '/var/lib/bugzilla/params':
      group   => 'apache',
      mode    => '0640',
      content => template('bugzilla/params'),
      require => Package['bugzilla'],
    }

    apache::webapp_other { 'bugzilla':
        webapp_file => 'bugzilla/webapp_bugzilla.conf',
    }

    $bugs_vhost = "bugs.$::domain"
    $vhost_root = '/usr/share/bugzilla/www'

    apache::vhost_redirect_ssl { $bugs_vhost: }

    apache::vhost_base { $bugs_vhost:
        aliases  => { '/bugzilla/' => $vhost_root },
        use_ssl  => true,
        location => $vhost_root,
        vhost    => $bugs_vhost,
    }

    subversion::snapshot { $bugzilla_location:
      source  => 'svn://svn.mageia.org/svn/web/templates/bugzilla/trunk',
      require => Package['bugzilla'],
    }

    file { 'custom':
      ensure  => directory,
      path    => '/usr/share/bugzilla/template/en/custom',
      group   => 'apache',
      mode    => '0640',
      recurse => true,
      require => Subversion::Snapshot[$bugzilla_location],
    }
}
