#!/usr/bin/ruby

def usage
	puts "Usage: #{$0} [options]"
	puts "Moves obsolete packages"
	puts
	puts "-h, --help		show help"
	puts "-m, --media <path>	path to the binary media"
	puts "-s, --src <path>	path to the associated src media"
	puts "-d, --destination <path>	path to the old packages storage"
end

require 'fileutils'
require 'getoptlong'
require 'readline'

opts = GetoptLong.new(
 [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
 [ '--archs', '-a', GetoptLong::REQUIRED_ARGUMENT ],
 [ '--base', '-p', GetoptLong::REQUIRED_ARGUMENT ],
 [ '--media', '-m', GetoptLong::REQUIRED_ARGUMENT ],
 [ '--bmedia', '-b', GetoptLong::REQUIRED_ARGUMENT ],
 [ '--smedia', '-s', GetoptLong::REQUIRED_ARGUMENT ],
 [ '--destination', '-d', GetoptLong::REQUIRED_ARGUMENT ],
 [ '--version', '-v', GetoptLong::REQUIRED_ARGUMENT ]
)

base_path = "<%= repository_root %>/distrib"
archs = [ "i586", "x86_64" ]
media = "core/release"
old_path = "<%= packages_archivedir %>"
version = "cauldron"

opts.each do |opt, arg|
	case opt
		when '--help'
			usage
			exit 0
		when '--bmedia'
			bin_path = arg.split(",")
		when '--smedia'
			src_path = arg
		when '--destination'
			old_path = arg
		when '--media'
			media = arg
		when '--archs'
			archs = arg.split(",")
		when '--base'
			base_path = arg
		when '--version'
			version = arg
	end
end

bin_path ||= archs.map{|arch| "#{base_path}/#{version}/#{arch}/media/#{media}" }
src_path ||= "#{base_path}/#{version}/SRPMS/#{media}"
debug_path = bin_path.map{|path| path.sub("/media/", "/media/debug/")}

$used_srcs = {}
$srcs = {}

# Get a list of all src.rpm

`urpmf --synthesis "#{src_path}/media_info/synthesis.hdlist.cz" --qf '%filename' "."`.each_line{|l|
	$srcs[l.rstrip] = true
}

# For each binary media:
# - Check if we have the src.rpm (else the binary package is obsolete)
# - Mark used src.rpm (if one is never marked, the src.rpm is obsolete)

def move_packages(src, dst, list)
	list.reject!{|f| !File.exist?(src + "/" + f)}
	return if list.empty?
	list.each{|b|
		puts b
	}
	puts "The #{list.length} listed packages will be moved from #{src} to #{dst}."
	line = Readline::readline('Are you sure [Yn]? ')
	if (line =~ /^y?$/i)
		list.each{|s|
			oldfile = src + "/" + s
			newfile = dst + "/" + s
			next unless File.exist?(oldfile)
			if (File.exist?(newfile))
				File.unlink(oldfile)
			else
				FileUtils.mv(oldfile, newfile)
			end
		}
	end
end

def check_binaries(path_list, old_path, mark_used)
	path_list.each{|bm|
		old_binaries = []
		`urpmf --synthesis "#{bm}/media_info/synthesis.hdlist.cz" --qf '%sourcerpm:%filename' ":"`.each_line{|l|
			l2 = l.split(':')
			src = l2[0]
			filename = l2[1].rstrip
			old_binaries << filename unless $srcs[src]
			$used_srcs[src] = true if mark_used
		}
		move_packages(bm, old_path, old_binaries)
	}
end

check_binaries(bin_path, old_path, true)
check_binaries(debug_path, old_path, false)

$used_srcs.keys.each{|s| $srcs.delete(s)}

move_packages(src_path, old_path, $srcs.keys)
