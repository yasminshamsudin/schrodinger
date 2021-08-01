#!/bin/bash

# By Yasmin 2020-02-04

# This script creates replicates of the Schrodinger-prepared MD-files

#~~~~~~~~~~~~~~~~~ EDIT HERE ~~~~~~~~~~~~~~~~~~~~

date=$( date +%y%m%d)             # Set the date to today's date
wdir=/scratch/users/yasminsh/LADH # Set the path for the folder where simulations are run

###################### NO MORE EDITS BEYOND THIS LINE !!! ################

cd $wdir/$date-*

for i in *
do
    for s in {1..5}   # Set the seed numbers!
      do
        mkdir s$s
        cp -r $i s$s

        # Generate random seeds
        RANGE=4000
        pseed=$RANDOM
        let "pseed %= $RANGE"

        # Change random seeds in cfg-file
        sed -i "s/seed = 2007/seed = $pseed/g" s$s/$i/$i.cfg
    done #s
done #i
#DONE
