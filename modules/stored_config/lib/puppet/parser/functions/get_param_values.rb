require 'puppet/rails'

# function :
#  get_param_values($name, $type, $param_name)
#    -> return the value corresponding to $param_name for the $name object of type $type

module Puppet::Parser::Functions
    newfunction(:get_param_values, :type => :rvalue) do |args|
        resource_name = args[0]
        exported_type = args[1]
        param_name = args[2]
        Puppet::Rails.connect()
        # TODO use find_each
        # TODO fail more gracefully when nothing match
        #       using a default value, maybe ?
        return Puppet::Rails::ParamValue.find(:first,
                                              :joins => [ :resource, :param_name ], 
                                              :conditions => { :param_names => {:name => param_name },
                                                               :resources => { :exported => true, 
                                                                               :restype => exported_type,
                                                                               :title => resource_name,
                                                                             } }
                                             ).value
    end
end
