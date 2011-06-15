class access_classes {
 
  # beware , theses classes are exclusives
  # if you need multiple group access, you need to define you own class
  # of access  
 
  # for server where only admins can connect
  class admin {
    pam::multiple_ldap_access { "admin":
        access_classes => ['mga-sysadmin']
    }
  }

  # for server where people can connect with ssh ( git, svn )
  class committers {
    # this is required, as we force the shell to be the restricted one
    # openssh will detect if the file do not exist and while refuse to log the
    # user, and erase the password ( see pam_auth.c in openssh code, seek badpw )
    # so the file must exist
    # permission to use svn, git, etc must be added separatly

    pam::multiple_ldap_access { "committers":
        access_classes => ['mga-shell_access'],
        restricted_shell => true,
    }
  }

  class iso_makers {
    pam::multiple_ldap_access { "iso_makers":
      access_classes => ['mga-iso_makers','mga-sysadmin']
    }
  }

  class web {
    pam::multiple_ldap_access { "web":
      access_classes => ['mga-web','mga-sysadmin']
    }
  }

  class web_and_artwork {
    pam::multiple_ldap_access { "web_artwork":
      access_classes => ['mga-web','mga-sysadmin','mga-artwork']
    }
  }
}
