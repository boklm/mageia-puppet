package Youri::Repository::Mageia;

=head1 NAME

Youri::Repository::Mageia - Mageia repository implementation

=head1 DESCRIPTION

This module implements Mageia repository

=cut

use warnings;
use strict;
use Carp;
use Memoize;
use File::Find 'find';
use base qw/Youri::Repository/;
use MDV::Distribconf::Build;
use SVN::Client;
use Sys::Hostname;

use constant {
    PACKAGE_CLASS   => 'Youri::Package::RPM::URPM',
    PACKAGE_CHARSET => 'utf8'
};

memoize('_get_media_config');

my %translate_arch = (
    i386 => 'i586',
    sparc64 => 'sparcv9',
);

sub _init {
    my $self   = shift;
    my %options = (
        noarch => 'i586', # noarch packages policy
	src => 'i586',
	install_root => '',
        test          => 0,  # test mode
        verbose       => 0,  # verbose mode
	queue	      => '',
	rejected      => '',
        @_
    );
    foreach my $var ('upload_state') {
	$self->{"_$var"} = [];
	foreach my $value (split ' ', $options{$var}) {
	    push @{$self->{"_$var"}}, $value
	}
    }
    print "Initializing repository\n";
    foreach my $v ('rejected', 'svn', 'queue', 'noarch', 'install_root', 'upload_root', 'verbose') {
        $self->{"_$v"}  = $options{$v}
    }
    foreach my $target (@{$options{targets}}) {
	$self->{$target} = [];
	print "Adding $target ($options{$target}{arch})\n" if $self->{_verbose};
	foreach my $value (split ' ', $options{$target}{arch}) {
	    push @{$self->{_arch}{$target}}, $value;
	    push @{$self->{_extra_arches}}, $value
	}
    }
    $self
}

sub get_group_id {
    my ($user) = @_;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);
    $year+=1900;
    $mon++;
    my ($host) = hostname =~ /([^.]*)/;
    sprintf "$year%02d%02d%02d%02d%02d.$user.$host.${$}_", $mon, $mday, $hour, $min, $sec;
}

sub get_target_arch {
    my ($self, $target) = $_;
    return $self->{_arch}{$target}
}

sub set_arch_changed {
    my ($self, $target, $arch) = @_;
    if ($arch eq 'noarch') {
	    $self->{_arch_changed}{$_} = 1 foreach @{$self->{_arch}{$target}}
    } elsif ($arch eq 'src') {
	    $self->{_arch_changed} = $self->{_src}
    } else {
	$self->{_arch_changed}{$arch} = 1
    }
}

sub get_arch_changed {
    my ($self, $target) = @_;
    return [ keys %{$self->{_arch_changed}} ]
}

sub set_install_dir_changed {
    my ($self, $install_dir) = @_;
    $self->{_install_dir_changed}{$install_dir} = 1;
}

sub get_install_dir_changed {
    my ($self) = @_;
    return [ keys %{$self->{_install_dir_changed}} ];
}

sub _get_media_config {
    my ($self, $target) = @_;
    my %media;
    my $real_target = $target;
    $real_target =~ s/_force//;
    foreach my $arch (@{$self->{_arch}{$target}}) {
	my $root = "$self->{_install_root}/$real_target/$arch";
	my $distrib = MDV::Distribconf::Build->new($root);
	print "Getting media config from $root\n" if $self->{_verbose};
	$self->{distrib}{$arch} = $distrib;
	$distrib->loadtree or die "$root does not seem to be a distribution tree\n";
	$distrib->parse_mediacfg;
	foreach my $media ($distrib->listmedia) {
	    my $rpms = $distrib->getvalue($media, 'rpms');
	    my $debug_for = $distrib->getvalue($media, 'debug_for');
	    my $srpms = $distrib->getvalue($media, 'srpms');
	    my $path = $distrib->getfullpath($media, 'path');
	    if (!$rpms) {
		if (-d $path) {
		    print "MEDIA defining $media in $path\n" if $self->{_verbose} > 1;
		    $media{$arch}{$media} = $path
		} else {
		    print "ERROR $path does not exist for media $media on $arch\n"
		}
	    } else {
		my ($media) = split ' ', $rpms;
		if (-d $path) {
		    print "MEDIA defining SOURCE media for $media in $path\n" if $self->{_verbose} > 1;
		    $media{src}{$media} = $path
		} else {
		    print "ERROR $path does not exist for source media $media on $arch\n"
		}
	    }
	}
    }
    \%media
}

sub get_package_class {
    return PACKAGE_CLASS;
}

sub get_package_charset {
    return PACKAGE_CHARSET;
}

sub get_upload_dir {
    my ($self, $package, $target, $user_context, $app_context) = @_;
    croak "Not a class method" unless ref $self;
    my $arch = $package->get_arch();
    return
        $self->{_upload_root} .
        "/$self->{_queue}/$target/" .
        _get_section($self, $package, $target, $user_context, $app_context) .
	'/' . 
	($user_context->{prefix} ? '' : get_group_id($user_context->{user}))
}

sub get_install_path {
    my ($self, $package, $target, $user_context, $app_context) = @_;

    return $self->_get_path($package, $target, $user_context, $app_context);
}


sub get_distribution_paths {
    my ($self, $package, $target) = @_;

    return $self->_get_distribution_paths($package, $target);
}

=head2 get_distribution_roots()

Returns distribution roots (ie install_root + target + arch)
(it returns a list in case of noarch)

=cut

sub get_distribution_roots {
    my ($self, $package, $target) = @_;
    croak "Not a class method" unless ref $self;

    map { 
	$self->_get_dir($self->{_install_root}, $_);
    } $self->_get_distribution_paths($package, $target);
}

sub get_archive_path {
    my ($self, $package, $target, $user_context, $app_context) = @_;

    return $self->_get_path($package, $target, $user_context, $app_context);
}

sub get_reject_path {
    my ($self, $package, $target, $user_context, $app_context) = @_;

    return $self->{_rejected};
}


sub _get_path {
    my ($self, $package, $target, $user_context, $app_context) = @_;

    my $section = $self->_get_section($package, $target, $user_context, $app_context);
    my $arch = $app_context->{arch} || $package->get_arch();
    $arch = $translate_arch{$arch} || $arch;
    if ($arch eq 'noarch') {
	$arch = $self->{_noarch} 
    } elsif ($arch eq 'src') {
	return "$target/SRPMS/$section"
    }
    "$target/$arch/media/$section"
}

sub _get_distribution_paths {
    my ($self, $package, $target) = @_;

    my $arch = $package->get_arch();
    $arch = $translate_arch{$arch} || $arch;
    if ($arch eq 'noarch') {
	map { "$target/$_" } $self->get_extra_arches;
    } elsif ($arch eq 'src') {
	die "no way to get distribution path using a $arch package";
    } else {
	"$target/$arch";
    }
}

sub get_arch {
    my ($self, $package, $target, $user_context, $app_context) = @_;
    my $arch = $package->get_arch();
    $arch = $translate_arch{$arch} || $arch;
    if ($arch eq 'noarch') {
	$arch = $self->{_noarch} 
    }
    $arch
}

sub get_version_path {
    my ($self, $package, $target, $user_context, $app_context) = @_;

    my $section = $self->_get_section($package, $target, $user_context, $app_context);

    return "$self->{_module}/$section";
}

=head2 get_replaced_packages($package, $target, $user_context, $app_context)

Overrides parent method to add libified packages.

=cut

sub get_replaced_packages {
    my ($self, $package, $target, $user_context, $app_context) = @_;
    croak "Not a class method" unless ref $self;

    my @replaced_packages = 
        $self->SUPER::get_replaced_packages($package, $target, $user_context, $app_context);

    # mandriva lib policy:
    # library package names change with revision, making mandatory to
    # duplicate older revisions search with a custom pattern
    my $name = $package->get_name();
    if ($name =~ /^(lib\w+[a-zA-Z_])[\d_\.]+([-\w]*)$/) {
        push(@replaced_packages,
            grep { $package->compare($_) > 0 }
            map { PACKAGE_CLASS->new(file => $_) }
            $self->get_files(
                $self->{_install_root},
                $self->get_install_path($package, $target, $user_context, $app_context),
                PACKAGE_CLASS->get_pattern(
                    $1 . '[\d_\.]+' . $2, # custom name pattern
                    undef,
                    undef,
                    $package->get_arch()
                ),
            )
        );
    }

    # kernel packages have the version in the name
    # binary dkms built for old kernels have to be removed too
    if ($name =~ /^kernel-([^\d]*-)?([\d.]*)-(.*)$/) { # "desktop", "2.6.28", "2mnb"
        push(@replaced_packages,
            map { PACKAGE_CLASS->new(file => $_) }
            $self->get_files(
                $self->{_install_root},
                $self->get_install_path($package, $target, $user_context, $app_context),
                PACKAGE_CLASS->get_pattern(
                    '(kernel-' . $1 . '\d.*|.*-kernel-[\d.]*-' . $1 . '\d.*)',
                    undef,
                    undef,
                    $package->get_arch()
                ),
            )
        );
    }

    return @replaced_packages;
       
}

sub _get_main_section {
    my ($self, $package, $target, $user_context, $app_context) = @_;

    my $section = $self->_get_section($package, $target, $user_context, $app_context);
    my ($main_section) = $section =~ m,^([^/]+),;
    $main_section
}

sub _get_section {
    my ($self, $package, $target, $user_context, $app_context) = @_;

    my $name = $package->get_name();
    my $cname = $package->get_canonical_name();
    my $version = $package->get_version();
    my $release = $package->get_release();
    my $section = $user_context->{section};
    my $media = $self->_get_media_config($target);
    my $arch = $package->get_arch();
    my $file = $package->as_file();
    $file =~ s,/+,/,g; # unneeded?
    # FIXME: use $self->get_arch()
    $arch = $self->{_noarch} if $arch eq 'noarch';
    $arch = $translate_arch{$arch} || $arch;

    if (!$section) {
        $section = $self->{packages}{$file}{section};
        print "Section undefined, repository says it is '$section' for '$file'\n" if $self->{_verbose};
    }
    # FIXME: use debug_for info
    if ($section && $section !~ m|debug/| && $package->is_debug()) {
	$section = "debug/$section"
    }

    # if have section already, check if it exists, and may return immediately
    if ($section) {
	print "Using requested section $section\n" if $self->{_verbose};
	if ($media->{$arch}{$section}) { 
	    return $section
	} else {
	    die "FATAL youri: unknown section $section for target $target for arch $arch\n"
	}
    }
    # else, try to find section automatically

    # pattern for search of src package with specific version-release,
    # should be searched first, because we prefer to find the precise
    # section a package is already in
    my $specific_source_pattern = PACKAGE_CLASS->get_pattern(
        $cname,
        $version,
        $release,
        'src'
    );

    my $source_pattern = PACKAGE_CLASS->get_pattern(
        $cname,
        undef,
        undef,
        'src'
    );

    # if a media has no source media configured, or if it is a debug
    # package, we search in binary media

    # pattern for search when a binary media has no src media configured
    my $specific_binary_pattern = PACKAGE_CLASS->get_pattern(
          $name,
          $version,
          $release,
          $arch
    );

    # last resort pattern: previous existing binary packages
    my $binary_pattern = PACKAGE_CLASS->get_pattern(
          $name,
          undef,
          undef,
          $arch
    );

    # first try to find section for the specific version, as it is possibly already there;
    # this is the case for when called in Youri::Submit::Action::Archive, to find the
    # section the package got installed
    print "Looking for package $name with version $version-$release\n" if $self->{_verbose};
    foreach my $m (keys %{$media->{$arch}}) {
        print " .. section '$m' path '".$media->{$arch}{$m}."'\n" if $self->{_verbose};
        # - prefer source for non-debug packages, use binary if there is no source media configured
        # - debug packages must be searched in binary medias, due to their
        #   src section != binary section; NOTE: should/need we search in
        #   src medias and add the 'debug_' prefix?
        if (!$package->is_debug() && $media->{src}{$m}) {
            next unless $self->get_files('', $media->{src}{$m}, $specific_source_pattern);
        } else {
            next unless $self->get_files('', $media->{$arch}{$m}, $specific_binary_pattern);
        }
        $section = $m;
        last;
    }

    # if still not found, try finding any version of the package in a
    # /release subsection (safe default: /release is default for cooker,
    # should be locked for released distros, and we don't risk wrongly
    # choosing /backports, /testing, or /updates);
    # this is the case for when called at submit, to find the section where
    # the package already resides
    if (!$section) {
        # debug packages should be found by previous specific version search
        # NOTE: as above, should/need we search here and add the 'debug_' prefix?
        # ... probably... as at least mga-youri-submit-force will process debug packages
        if ($package->is_debug() && $self->{_verbose}) {
            print "Warning: debug package $name with version $version-$release not found.\n";
        }

        print "Warning: Looking for any section with a package $name of any version\n";
        foreach my $m (keys %{$media->{$arch}}) {
            print " .. section '$m' path '".$media->{$arch}{$m}."'\n" if $self->{_verbose};
            # NOTE: !$package->is_debug() test is here to prevent when above FATAL error is removed
            next if $m !~ /release/ || ($m =~ /debug/ && !$package->is_debug());
            # - prefer source
            if ($media->{src}{$m}) {
                next unless $self->get_files('', $media->{src}{$m}, $source_pattern);
            } else {
                next unless $self->get_files('', $media->{$arch}{$m}, $binary_pattern);
            }
            $section = $m;
            last;
        }
    }

    # FIXME: doing this here is wrong; this way the caller can never know if
    # a section was actually found or not; should return undef and let the
    # caller set a default (Note: IIRC PLF|Zarb has this right, see there) -spuk
    print STDERR "Warning: Can't guess destination: section missing, defaulting to core/release\n" unless $section;
    $section ||= 'core/release';

    # next time we don't need to search everything again
    $self->{packages}{$file}{section} = $section;

    print "Section is '$section'.\n" if $self->{_verbose};

    return $section;
}

sub get_upload_newer_revisions {
    my ($self, $package, $target, $user_context, $app_context) = @_;
    croak "Not a class method" unless ref $self;
    my $arch = $package->get_arch();
    my $name = $package->get_full_name;
    $name =~ s/^\@\d+://;
    my $pattern = $self->get_package_class()->get_pattern($package->get_name(), undef, undef, $arch);
    my $media = $self->_get_media_config($target);
    my @packages;
    foreach my $state (@{$self->{_upload_state}}) {
	foreach my $m (keys %{$media->{$arch}}) {
	    my $path = "$self->{_upload_root}/$state/$target/$m";
	    print "Looking for package $package revisions for $target in $path (pattern $pattern)\n" if $self->{_verbose};
	    find(
		sub { 
		    s/\d{14}\.[^.]*\.[^.]*\.\d+_//; 
		    s/^\@\d+://;
		    return if ! /^$pattern/; 
		    return if /\.info$/; 
		    print "Find $_\n" if $self->{_verbose} > 1; 
		    push @packages, $File::Find::name if $package->check_ranges_compatibility("== $name", "< $_")
		}, $path);
	}
    }
    return
        @packages;
}

sub package_in_svn {
    my ($self, $srpm_name) = @_;
    my $ctx = new SVN::Client(
	auth => [SVN::Client::get_simple_provider(),
	SVN::Client::get_simple_prompt_provider(\&simple_prompt,2),
	SVN::Client::get_username_provider()]
    );

    my $svn_entry = $ctx->ls("$self->{_svn}/$srpm_name", 'HEAD', 0);
    if ($svn_entry) {
	print "Package $srpm_name is in the SVN\n" if $self->{_verbose};
	return 1
    }
}

sub get_svn_url {
    my ($self) = @_;
    $self->{_svn}
}

sub get_revisions {
    my ($self, $package, $target, $user_context, $app_context, $filter) = @_;
    croak "Not a class method" unless ref $self;
    print "Looking for package $package revisions for $target\n" if $self->{_verbose} > 0;

    my $arch = $app_context->{arch} || $user_context->{arch} || $package->get_arch();
    my $media_arch = $arch eq 'noarch' ? $self->{_noarch} : $arch;
    my $path = $arch eq 'src' ? "$target/SRPMS/" : "$target/$media_arch/media";
    my $media = $self->_get_section($package, $target, $user_context, $app_context);
    my $name = $package->get_name();
    my @packages = map { $self->get_package_class()->new(file => $_) }
	$self->get_files(
	    $self->{_install_root},
	    "$path/$media",
	    $self->get_package_class()->get_pattern(
		    $name,
		undef,
		undef,
		$package->get_arch(),
	    )
	);

    @packages = grep { $filter->($_) } @packages if $filter;

    return
        sort { $b->compare($a) } # sort by revision order
        @packages;
}

sub reject {
    my ($self, $package, $target, $user_context, $app_context) = @_;
    croak "Not a class method" unless ref $self;


}

sub get_archive_dir {
    my ($self, $package, $target, $user_context, $app_context) = @_;
    croak "Not a class method" unless ref $self;

    return
        $self->{_archive_root}
}


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2002-2006, YOURI project
Copyright (C) 2006,2007,2009  Mandriva
Copyright (C) 2011      Nicolas Vigier, Michael Scherer, Pascal Terjan

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

1;
