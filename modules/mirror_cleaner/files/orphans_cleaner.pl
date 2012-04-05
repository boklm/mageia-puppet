#!/usr/bin/perl

# this script will look at the list of rpm, and move orphan to a directory, if they are too old
# another script should take care of cleaning this directory ( or puppet )

use strict;
use RPM4;
use File::stat;
use File::Basename;
use File::Copy;
use File::Path qw(make_path);

my @arches = ('i586','x86_64');
my @sections = ('core','nonfree','tainted');
my @medias = ('backports', 'backports_testing', 'release',  'updates',  'updates_testing');
my $move_delay = 60*60*24*14;

my ($path, $dest_path) = @ARGV;

my $qf = "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}.rpm %{SOURCERPM}";

my %hash ;
my ($filename, $srpm, $dest_rpm);


my ($source_hdlist, $binary_hdlist, $rpm_path, $srpm_path);

foreach my $a ( @arches ) {
        foreach my $s ( @sections ) {
                foreach my $m ( @medias ) {

                        $rpm_path = "$path/$a/media/$s/$m";
                        $srpm_path = "$path/SRPMS/$s/$m";
                        $binary_hdlist = "$rpm_path/media_info/hdlist.cz";
                        $source_hdlist = "$srpm_path/media_info/hdlist.cz";

			next if not -f $source_hdlist;
			next if not -f $binary_hdlist;

			next if stat($source_hdlist)->size() <= 64;
			next if stat($binary_hdlist)->size() <= 64;

                        open(my $hdfh, "zcat '$binary_hdlist' 2>/dev/null |") or die "Can't open $_";
                        while (my $hdr = stream2header($hdfh)) {
                                ($filename, $srpm) = split(/ /,$hdr->queryformat($qf));
                                push(@{$hash{$srpm}}, $filename);
                        }
                        close($hdfh);


                        open($hdfh, "zcat '$source_hdlist' 2>/dev/null |") or die "Can't open $_";
                        while (my $hdr = stream2header($hdfh)) {
                                $srpm = $hdr->queryformat("%{NAME}-%{VERSION}-%{RELEASE}.src.rpm");
                                delete $hash{$srpm}; 
                        }
                        close($hdfh);

                        foreach my $s ( keys %hash )
                        {
                                # Be safe, maybe hdlists were not in sync
                                next if -f "$srpm_path/$s";
                                foreach my $rpm ( @{$hash{$s}} ) {
					$rpm = "$rpm_path/$rpm";
					# sometimes, packages are removed without hdlist to be updated
					next if not -f "$rpm";
					if (time() > $move_delay + stat("$rpm")->ctime()) {
						( $dest_rpm = $rpm ) =~ s/$path/$dest_path/;
						my $dir = dirname $dest_rpm;
						make_path $dir if not -d $dir;
						move($rpm, $dest_rpm)
					}
                                }
                        }
                }
        }
}
