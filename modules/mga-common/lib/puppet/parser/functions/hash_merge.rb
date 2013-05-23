module Puppet::Parser::Functions
    newfunction(:hash_merge, :type => :rvalue) do |args|
	unless args[0].is_a?(Hash) and args[1].is_a?(Hash)
	    Puppet.warning "hash_merge takes two arguments"
	    nil
	else
	    print "hash_merge\n"
	    args[0].merge(args[1])
	end
    end
end
