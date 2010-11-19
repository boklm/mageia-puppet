#!/bin/sh
for script in $0.d/*; do
    if [ ! -x "$script" ]; then
        continue
    fi

    if [[ "$script" == *~ ]]; then
        continue
    fi

    $script $@ || exit 1
done

