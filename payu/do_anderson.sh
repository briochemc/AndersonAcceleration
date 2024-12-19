#!/bin/bash
#PBS -P xv83
#PBS -q express
#PBS -l walltime=0:10:00
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -l storage=gdata/hh5+gdata/xv83+scratch/xv83+gdata/vk83
#PBS -l wd
#PBS -j oe
#PBS -l software=matlab_unsw

# BENOIT: Check archive directory.
# IF model has not completed 10 years, then do nothing.
# IF model has completed 10 years, submit matlab job.

# scratchdir=/scratch/xv83/dkh157/mom/archive/age_n10
scratchdir=/scratch/scratch/xv83/bp3051/AA
cd ${scratchdir}/anderson

module load matlab
module load matlab_licence
matlab -nosplash -nojvm -singleCompThread < age_run.m >> $PBS_JOBID.log

cd ${scratchdir}/age_output
for x in `ls ocean_age.res_*.nc` ; do
    y=${x:14:4}
    ./compress_backup.py $x age_comp_${y}.nc
    if [ -f age_comp_${y}.nc ]; then
        rm $x
    fi
done
