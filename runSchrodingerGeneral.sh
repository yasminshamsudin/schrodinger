#!/bin/bash

################ CHANGELOG ###################################
# By Yasmin 2020-02-04 
# EDITED 2021-03-08 for single-seed runs
# EDITED 2021-03-08 for fixed wdir
# EDITED 2021-03-08 changing -p owners to gpu
# EDITED 2021-03-08 adapting the time for 1ns runs
# TESTED 2021-03-08 on Desmond multiple runs
# EDITED 2021-03-22 fetches info from original .sh file
# TESTED 2021-03-22 on Desmond, Epik, MacroModel, Jaguar
##############################################################

# This script sets up and starts Schrodinger runs

############## Edit only this section #############

wdir=$SCRATCH/JAGUAR/210608_D2O	# Folder containing run files
reqTime=10:00:00		# Requested time on Sherlock

############## No more editing!!! #################

cd $wdir

 for i in * 
 do
 system=$( echo "$i" )
 cd $system/

  for s in *.sh
  do
  inputfile=$( echo "$s" | sed -e 's/\.sh//g')
  
# Create the submitfile
 # Create Sherlock flags
 echo -e "#!/bin/bash" > flag.job
 echo -e "#SBATCH --mail-type=ALL" >> flag.job
 echo -e "#SBATCH --job-name=$system" >> flag.job
 echo -e "#SBATCH -p hns,gpu,owners" >> flag.job
 echo -e "#SBATCH --gpus 1" >> flag.job
 echo -e "#SBATCH --time=$reqTime" >> flag.job
 echo -e "ml load chemistry schrodinger"'\n' >> flag.job

 cat flag.job $inputfile.sh > submit.job 
 rm flag.job
 
 # Make the file Sherlock-ready
# sed -i "s/\"${SCHRODINGER}/utilities/multisim\"/${SCHRODINGER}/utilities/multisim/g" submit.job
 sed -i "s/-HOST '<dummy-gpu-host>'/-HOST localhost/g" submit.job
 sed -i "s/-HOST/-WAIT -HOST/g" submit.job
 sed -i "s/-o /-set stage[1].set_family.md.jlaunch_opt=["-gpu"] -o /g" submit.job
 sed -i 's/DESMOND_GPGPU:16/"DESMOND_GPGPU:16"/g' submit.job 

 # Submit the calculation
 sbatch submit.job

  done #inputfile
cd ..
done #system
