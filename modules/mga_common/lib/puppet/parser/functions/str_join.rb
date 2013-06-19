# str_join($array, $sep)
#   -> return a string created by converting each element of the array to
#   a string, separated by $sep

module Puppet::Parser::Functions
    newfunction(:str_join, :type => :rvalue) do |args| 
	array = args[0]
	sep = args[1]
	return array.join(sep)
    end
end
