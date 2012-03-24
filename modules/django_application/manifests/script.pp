define django_application::script() {
    file { $name:
        path   => "/usr/local/bin/$name",
        mode   => '0755',
        source => "puppet:///modules/django_application/$name",
    }
}


