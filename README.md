# schrodinger

<b>For Sherlock users who have prepared their simulations on desktop versions of Schrodinger</b>

If the user prepare the system for simulations they can write the input files for the simulations and upload them to Schrodinger. The file with the .sh filetype contains the run command for Schrodinger. It can look something like this:

"${SCHRODINGER}\utilities\multisim" -JOBNAME desmond_md_job_1 -HOST "<dummy-gpu-host>" -maxjob 1 -cpu 1 -m desmond_md_job_1.msj -c desmond_md_job_1.cfg -description "Molecular Dynamics" desmond_md_job_1.cms -mode umbrella -set stage[1].set_family.md.jlaunch_opt=["-gpu"] -o desmond_md_job_1-out.cms -lic "DESMOND_GPGPU:16"

<b>This file can be altered to make it Sherlock-ready by following these steps:</b>

<h3>1.	Add the SBATCH commands</h3>

Example:

#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --job-name=test
#SBATCH -p hns,iric,owners
#SBATCH --gpus 1
#SBATCH --time=05:00:00

<h3>2.	Add a line to load the Schrodinger module</h3>

ml load chemistry schrodinger

<h3>3.	Make the following changes in the command:</h3>

<h4>a)	If the files were generated on a Windows machine, change the</h4>
"${SCHRODINGER}\utilities\multisim" 
to 
${SCHRODINGER}/utilities/multisim

<h4>b)	Change </h4>
-HOST "/<dummy-gpu-host/>" 
To 
-HOST localhost

<h4>c)	Add the -WAIT command somewhere in the command.</h4>

<h3>The final file would look something like this:</h3>

#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --job-name=test
#SBATCH -p hns,iric,owners
#SBATCH --gpus 1
#SBATCH --time=05:00:00
ml load chemistry schrodinger
${SCHRODINGER}/utilities/multisim -JOBNAME C46_174S_20ns -WAIT -HOST localhost -maxjob 1 -cpu 1 -m C46_174S_20ns.msj -c C46_174S_20ns.cfg -description "Molecular Dynamics" C46_174S_20ns.cms -mode umbrella -set stage[1].set_family.md.jlaunch_opt=["-gpu"] -o C46_174S_20ns-out.cms -lic "DESMOND_GPGPU:16"
