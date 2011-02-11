#!/bin/bash

while read line
do
    # --local is a option for the newer git
    git config --add $line
done < config.puppet        
