class django_application {
    package { ['python-django','python-psycopg2','python-django-auth-ldap']:
        ensure => installed
    }

    file { "custom_backend.py":
        path => "/usr/local/lib/custom_backend.py",
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        source => "puppet:///modules/django_application/custom_backend.py",
        notify => Service['apache']
    }
}
