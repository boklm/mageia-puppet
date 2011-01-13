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

  define multiple_ldap_access($access_classes) {
    include base
  }
 
  # beware , this two classes are exclusives
  # if you need multiple group access, you need to define you own class
  # of access  
 
  # for server where only admins can connect
  class admin_access {
    multiple_ldap_access { "admin_access":
        access_classes => ['mga-sysadmin']
    }
  }

  # for server where people can connect with ssh ( git, svn )
  class committers_access {
    # this is required, as we force the shell to be the restricted one
    # openssh will detect if the file do not exist and while refuse to log the
    # user, and erase the password ( see pam_auth.c in openssh code, seek badpw )
    # so the file must exist
    # permission to use svn, git, etc must be added separatly
     
    include restrictshell::shell

    multiple_ldap_access { "committers_access":
        access_classes => ['mga-commiters']
    }
  }
}
