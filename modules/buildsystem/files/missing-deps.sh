#!/bin/sh

# Copyright 2011, Pascal Terjan <pterjan@gmail.com>
#
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
#
# Creates missing-deps.$arch.txt for each arch, listing broken
# dependencies inside the associated media.

repo="/distrib/bootstrap/distrib/cauldron"

missing() {
	arch=$1
	d="${repo}/${arch}"
	urpmf --requires --use-distrib $d : | cut -d: -f2- | sed 's/\[.*//' | sort -u | xargs urpmq -p --use-distrib $d 2>&1 >/dev/null | sed -n 's/No package named //p'
}

for arch in i586 x86_64
do
	missing $arch > missing-deps.$arch.txt
done
