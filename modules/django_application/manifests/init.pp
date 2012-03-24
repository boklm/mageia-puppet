# this class hold the common stuff for all django applications
# as we cannot declare the same ressource twice ( ie,
# python-psycopg2 for example )
# it is required to place this in a common class
class django_application {
    package {['python-django',
              'python-psycopg2',
              'python-django-auth-ldap']: }

    file { '/usr/local/lib/custom_backend.py':
        source => 'puppet:///modules/django_application/custom_backend.py',
        notify => Service['apache']
    }

    django_application::script { ['django_create_group.py',
                                  'django_add_permission_to_group.py']: }

}
