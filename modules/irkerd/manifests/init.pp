class irkerd {
  package { 'irker':
    ensure => installed,
  }

  service { 'irkerd':
    ensure => running,
  }
}
