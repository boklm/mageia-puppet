require 'etc'
# group_members($group)
#   -> return a array with the login of the group members

module Puppet::Parser::Functions
    newfunction(:group_members, :type => :rvalue) do |args| 
        group = args[0]
        return Etc.getgrnam(group).mem
    end
end
