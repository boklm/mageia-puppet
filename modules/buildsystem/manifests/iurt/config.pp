define buildsystem::iurt::config() {
    $distribution = $name
    # TODO rename the variable too in template
    $build_login = $buildsystem::iurt::user::login

    file { "/etc/iurt/build/$distribution.conf":
        owner   => $build_login,
        group   => $build_login,
        content => template("buildsystem/iurt/$distribution.conf")
    }
}
