class pam {
    class base {
        package { ["pam_ldap","nss_ldap","nscd"]: }

        service { nscd:
            require => Package['nscd'],
        }

        file {
            "/etc/pam.d/system-auth": content => template("pam/system-auth");
            "/etc/nsswitch.conf": content => template("pam/nsswitch.conf");
            "/etc/ldap.conf": content => template("pam/ldap.conf");
        }

        $ldap_password = extlookup("${fqdn}_ldap_password",'x')
        file { "ldap.secret":
            path => "/etc/ldap.secret",
            mode => 600,
            content => $ldap_password
        }
    }

    define multiple_ldap_access($access_classes,$restricted_shell = false) {
        if $restricted_shell {
            include restrictshell
        }
        include base
    }
}
