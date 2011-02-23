# this class hold the common stuff for all django applications
# as we cannot declare the same ressource twice ( ie, python-psycopg2 for example )
# it is required to place this in a common class 
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
