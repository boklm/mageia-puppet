define django_application::create_group($path, $module) {
    exec { "/usr/local/bin/django_create_group.py $name":
        user        => 'root',
        environment => ["DJANGO_SETTINGS_MODULE=$module.settings",
                        "PYTHONPATH=$path" ],
        require     => Django_application::Script['django_create_group.py']
    }
}


