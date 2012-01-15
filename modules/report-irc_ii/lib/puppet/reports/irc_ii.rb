require 'puppet'
require 'yaml'

unless Puppet.version >= '2.6.5'
    fail "This report processor requires Puppet version 2.6.5 or later"
end

Puppet::Reports.register_report(:irc_ii) do
    configfile = File.join([File.dirname(Puppet.settings[:config]), "irc_ii.yaml"])
    raise(Puppet::ParseError, "XMPP report config file #{configfile} not readable") unless File.exist?(configfile)

    config = YAML.load_file(configfile)
    II_PATH = config[:ii_path]

    desc <<-DESC
              Send notification of failed reports to an IRC channel, using a existing ii setup.
    DESC

    def process
        if self.status == 'failed'
            message = "Puppet run for #{self.host} #{self.status} at #{Time.now.asctime}."
            Puppet::Util::SUIDManager.run_and_capture("echo #{message} > #{II_PATH}" , "nobody", "nogroup")
        end
    end
end
