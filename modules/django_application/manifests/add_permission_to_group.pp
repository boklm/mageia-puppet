define django_application::add_permission_to_group( $path,
                                                    $module,
                                                    $group,
                                                    $app='') {
    exec { "/usr/local/bin/django_add_permission_to_group.py $group $name $app":
        user        => 'root',
        environment => ["DJANGO_SETTINGS_MODULE=$module.settings",
                        "PYTHONPATH=$path" ],
        require     => Django_application::Script['django_add_permission_to_group.py']
    }
}

