#!/bin/bash

# By Yasmin 2020-02-04
# 2021-08-01 Formatting edits

# This script sets up and starts Schrodinger runs

############## EDIT HERE #################

 wdir=/scratch/users/yasminsh/LADH  # Set the path to the directory of all files
 date=$( date +%y%m%d)              # Sets today's date

 for s in {1..5}   # Set the seed numbers!

############## No more editing!!! #################

do

cd $wdir

for n in $date-*
 do
 workdir=$( echo "$n" )
 cd $n/s$s

 for i in *
 do
 system=$( echo "$i" )
 cd $system/

  for s in *.sh
  do
  inputfile=$( echo "$s" | sed -e 's/\.sh//g')

  # Create the submitfile
  echo -e "#!/bin/bash" > submit.job
  echo -e "#SBATCH --mail-type=ALL" >> submit.job
  echo -e "#SBATCH --job-name=$system-s$s" >> submit.job
  echo -e "#SBATCH -p hns,iric,owners" >> submit.job
  echo -e "#SBATCH --gpus 1" >> submit.job
  echo -e "#SBATCH --time=05:00:00" >> submit.job
  echo -e "ml load chemistry schrodinger"'\n' >> submit.job
  echo -e '${SCHRODINGER}/utilities/multisim -JOBNAME sysname -WAIT -HOST localhost -maxjob 1 -cpu 1 -m sysname.msj -c sysname.cfg -description "Molecular Dynamics" sysname.cms -mode umbrella -set stage[1].set_family.md.jlaunch_opt=["-gpu"] -o sysname-out.cms -lic "DESMOND_GPGPU:16"' >> submit.job

  sed -i "s/sysname/$inputfile/g" submit.job

 # Submit the calculation
 sbatch submit.job
  done #inputfile
cd ..
done #system
cd ..
done # workdir
done #seeds
