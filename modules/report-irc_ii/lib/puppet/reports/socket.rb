require 'puppet'
require 'yaml'

unless Puppet.version >= '2.6.5'
    fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:socket) do
    configfile = File.join([File.dirname(Puppet.settings[:config]), "socket.yaml"])
    raise(Puppet::ParseError, "Socket report config file #{configfile} not readable") unless File.exist?(configfile)

    config = YAML.load_file(configfile)
    SOCKET_PATH = config[:socket_path]
    # TODO add support for using another user ?

    desc <<-DESC
              Send notification of failed reports to a socket.
    DESC

    def process
        if self.status == 'failed'
            message = "Puppet run for #{self.host} #{self.status} at #{Time.now.asctime}."
            if File.exist?(SOCKET_PATH)
                Puppet::Util.execute("echo #{message} > #{SOCKET_PATH}" , "nobody", "nogroup")
            end
        end
    end
end
