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

# Don't do anything if payu is the middle of a job
# This happens because payu submits the postscript at the end of each 1-year run
# So if there is a restart000 but no restart009, then abort
archivedir=/home/561/bp3051/access-esm1.5/andersonacceleration_test/archive
restart000=${archivedir}/restart000
restart009=${archivedir}/restart009
if [ ! -d $restart000 ]; then
  echo "No archive:"
  echo "  $restart000 does not exist"
fi
if [ -d $restart000 ] && [ ! -d $restart009 ]; then
  echo "Aborting because in middle of payu run cycle:"
  echo "  $restart000 exists"
  echo "  but $restart009 does not exist"
  exit 1
fi

echo "  $restart009 exists"


# 1. run `age_run.m`

# CHECK BP: Maybe I can use the path to this repo instead to run `age_run`
andersondir=/home/561/bp3051/Projects/AndersonAcceleration
cd ${andersondir}/matlab

module load matlab
module load matlab_licence
matlab -nosplash -nojvm -singleCompThread < age_run.m >> $PBS_JOBID.log



# 2. clean up / compress backup (commented out for now)

# # CHECK BP: that the name here is correct
# scratchdir=/scratch/xv83/bp3051/access-esm/archive/AA_age
# cd ${scratchdir}/anderson

# cd ${scratchdir}/age_output
# for x in `ls ocean_age.res_*.nc` ; do
#     y=${x:14:4}
#     ./compress_backup.py $x age_comp_${y}.nc
#     if [ -f age_comp_${y}.nc ]; then
#         rm $x
#     fi
# done
