class pam {

  class base {
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
  } 
  
  # for server where only admin can connect
  class admin_access inherits base {
    $access_class = "admin"
    # not sure if this line is needed anymore, wil check later
    file { "system-auth": }
  }

  # for server where people can connect with ssh ( git, svn )
  class commiters_access inherits base {
    $access_class = "commiters"
    file { "system-auth": }
  }
}
