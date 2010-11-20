Facter.add("dc_suffix") do
    setcode do
        begin
            Facter.domain
        rescue 
            Facter.loadfacts()
        end
        dc_suffix = 'dc=' + Facter.value('domain').gsub('.',',dc=')
    end
end    
