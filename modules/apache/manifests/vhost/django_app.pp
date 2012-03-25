define apache::vhost::django_app ($module = false,
                                  $module_path = false,
                                  $use_ssl = false,
                                  $aliases= {}) {
    include apache::mod::wsgi
    apache::vhost::base { $name:
        use_ssl => $use_ssl,
        content => template('apache/vhost_django_app.conf'),
        aliases => $aliases,
    }

    # module is a ruby reserved keyword, cannot be used in templates
    $django_module = $module
    file { "$name.wsgi":
        path    => "/usr/local/lib/wsgi/$name.wsgi",
        mode    => '0755',
        notify  => Service['apache'],
        content => template('apache/django.wsgi'),
    }
}


