# for server where people can connect with ssh ( git, svn )
class access_classes::committers {
    # this is required, as we force the shell to be the restricted one
    # openssh will detect if the file do not exist and while refuse to log the
    # user, and erase the password ( see pam_auth.c in openssh code,
    # seek badpw )
    # so the file must exist
    # permission to use svn, git, etc must be added separatly

    class { pam::multiple_ldap_access:
        access_classes   => ['mga-shell_access'],
        restricted_shell => true,
    }
}
