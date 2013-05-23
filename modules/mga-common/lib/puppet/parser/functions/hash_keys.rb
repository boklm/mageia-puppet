module Puppet::Parser::Functions
    newfunction(:hash_keys, :type => :rvalue) do |args|
	unless args[0].is_a?(Hash)
	    Puppet.warning "hash_keys takes one argument, the input hash"
	    nil
	else
	    args[0].keys
	end
    end
end
