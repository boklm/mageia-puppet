class pam {

  package { ["pam_ldap","nss_ldap", "pam_mkhomedir"]:
    ensure => installed,  
  }


  file { "system-auth":
     path => "/etc/pam.d/system-auth",
     owner => root,
     group => root,
     mode => 644,
     content => template("openldap/system-auth")
  }
  
  # for server where only admin can connect
  class admin_access {
    $access_class = "admin"
    file { "system-auth": }
  }

  # for server where people can connect with ssh ( git, svn )
  class commiters_access {
    $access_class = "commiters"
    file { "system-auth": }
  }
}
