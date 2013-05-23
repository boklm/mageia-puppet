define buildsystem::iurt::config() {
    include buildsystem::var::iurt
    include buildsystem::var::webstatus
    $distribution = $name
    # TODO rename the variable too in template
    $build_login = $buildsystem::var::iurt::login

    file { "/etc/iurt/build/$distribution.conf":
        owner   => $build_login,
        group   => $build_login,
        content => template("buildsystem/iurt.conf")
    }
}
