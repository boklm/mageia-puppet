Facter.add("wildcard_sslcert") do
	setcode do
		begin
			Facter.domain
		rescue
			Facter.loadfacts()
		end
		sslfiles = '/etc/ssl/wildcard.' + Facter.value('domain')
		if File.exist?(sslfiles + '.crt') and File.exist?(sslfiles + '.key') \
			and File.exist?(sslfiles + '.pem')
			true
		else
			false
		end
	end
end
