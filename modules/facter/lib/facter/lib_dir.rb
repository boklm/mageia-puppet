Facter.add("lib_dir") do
    setcode do
        begin
            Facter.architecture
        rescue 
            Facter.loadfacts()
        end
        '/usr/lib' + ( Facter.value('architecture') == "x86_64" ? '64' : '') + '/'
    end
end    
