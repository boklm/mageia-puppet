#!/bin/bash

# clean old draklive build sets
DRAKLIVE_ROOT=/var/lib/draklive
RM="echo rm -rf"

# keep only chroot/build sets from previous day
MAX_BUILD_AGE=1
find $DRAKLIVE_ROOT/{chroot/*,build/*/*} -maxdepth 0 -not -name dist -mtime +$(expr $MAX_BUILD_AGE - 1) -exec $RM {} \;

# keep dist (iso + lists) for all sets during 20 days
MAX_DIST_AGE=20
find $DRAKLIVE_ROOT/build/*/dist -maxdepth 0 -mtime +$(expr $MAX_DIST_AGE - 1) -exec $RM {} \;
