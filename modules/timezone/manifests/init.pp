define timezone( $tz = "GMT" ) {
    file { "/etc/localetime": 
        ensure => link, 
        target => "/usr/share/zoneinfo/$tz" 
    }
}
