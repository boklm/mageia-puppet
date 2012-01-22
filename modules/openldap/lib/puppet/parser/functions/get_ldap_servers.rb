# return a list of all ldap servers declared
module Puppet::Parser::Functions
    newfunction(:get_ldap_servers, :type => :rvalue) do |args| 
        Puppet::Parser::Functions.autoloader.loadall
        res = ["master"]
 
        function_list_exported_ressources(['Openldap::Exported_slave']).each { |i| 
              res << "slave-#{i}" 
        }
        res.map! { |x| "ldap-#{x}." + lookupvar("domain") }
        return res.join(" ")
    end
end
