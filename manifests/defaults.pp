# to not repeat the settings everywhere
Exec { 
    path => "/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin/", 
}

Package {
    ensure => "present",
}

File {
    ensure => "present",
    owner => root,
    group => root,
}

