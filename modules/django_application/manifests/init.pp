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

    define script() { 
        file { $name:
            path => "/usr/local/bin/$name",
            ensure => present,
            owner => root,
            group => root,
            mode => 755,
            source => "puppet:///modules/django_application/$name",
        }
    }

    script { ['django_create_group.py','django_add_permission_to_group.py']: 
    }

    define create_group($path,$module) {
        exec { "/usr/local/bin/django_create_group.py $name":
            user => root,
            environment => ["DJANGO_SETTINGS_MODULE=$module.settings",
                            "PYTHONPATH=$path" ],
            require => Django_application::Script['django_create_group.py']
        }
    }

    define add_permission_to_group($path,$module,$group, $app='') {
        exec { "/usr/local/bin/django_add_permission_to_group.py $group $name $app":
            user => root,
            environment => ["DJANGO_SETTINGS_MODULE=$module.settings",
                            "PYTHONPATH=$path" ],
            require => Django_application::Script['django_add_permission_to_group.py']
        }
    }
}
