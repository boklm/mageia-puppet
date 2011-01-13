class pam {

  class base {
      package { ["pam_ldap","nss_ldap","nscd"]:
        ensure => installed,  
      }

      service { nscd:
        ensure => running,
        path => '/etc/init.d/nscd',
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

      $ldap_password = extlookup("${fqdn}_ldap_password",'x')
      file { "ldap.secret":
         path => "/etc/ldap.secret",
         owner => root,
         group => root,
         mode => 600,
         content => $ldap_password
      }
 
      file { "ldap.conf":
         path => "/etc/ldap.conf",
         owner => root,
         group => root,
         mode => 644,
         content => template("pam/ldap.conf")
      }
  } 

  define multiple_ldap_access($access_classes,$restricted_shell = false) {
    if $restricted_shell {
      include restrictshell
    }
    include base
  }
}
