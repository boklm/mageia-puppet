require 'puppet/rails'

#  get_fact($node,$fact)
#    -> return the fact, from stored config

module Puppet::Parser::Functions
    newfunction(:get_fact, :type => :rvalue) do |args| 
        node = args[0]
        fact = args[1]
        # TODO use 
        # Puppet::Node::Facts.indirection.find(Puppet[:certname])
        Puppet::Rails.connect()
        return Puppet::Rails::FactValue.find( :first,
                                              :joins => [ :host, :fact_name ],
                                              :conditions => { :fact_names => {:name => fact },
                                                               :hosts => {:name => node }} 
                                            ).value
    end
end
