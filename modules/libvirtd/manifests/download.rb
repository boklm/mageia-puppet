define "libvirtd::download::netboot_images", :path, :versions, :archs, :mirror_path, :files do
    # example :
    # mandriva :
    # ftp://ftp.free.fr/pub/Distributions_Linux/MandrivaLinux/devel/%{version}/%{arch}/isolinux/alt0/
    for a in @archs do
        for v in @versions do
            # uncomment when ruby 1.9 will be stable and used 
            # mirror_file_path = @mirror_path % { :arch => a, :version => v } 
            mirror_file_path = @mirror_path.gsub(/%{arch}/, a)
            mirror_file_path = mirror_file_path.gsub(/%{version}/, v)
            for f in @files do 
                file_name = "#{@path}/#{@name}_#{v}_#{a}_#{f}" 
                create_resource(:exec, "wget -q #{mirror_file_path}/#{f} -o #{file_name}", 
                                :creates => file_name) 
            end
        end
    end
end



