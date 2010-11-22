class pam {

  class base {
      package { ["pam_ldap","nss_ldap"]:
        ensure => installed,  
      }

      file { "system-auth":
         path => "/etc/pam.d/system-auth",
         owner => root,
         group => root,
         mode => 644,
         content => template("pam/system-auth")
      }

      file { "nsswitch.conf":
         path => "/etc/nsswitch.conf",
         owner => root,
         group => root,
         mode => 644,
         content => template("pam/nsswitch.conf")
      }

      $nssldap_password = extlookup("nssldap_password",'x')
 
      file { "ldap.conf":
         path => "/etc/ldap.conf",
         owner => root,
         group => root,
         mode => 644,
         content => template("pam/ldap.conf")
      }
  } 
  
  # for server where only admin can connect
  class admin_access inherits base {
    $access_class = "admin"
    # not sure if this line is needed anymore, wil check later
  }

  # for server where people can connect with ssh ( git, svn )
  class commiters_access inherits base {
    $access_class = "commiters"
  }
}
