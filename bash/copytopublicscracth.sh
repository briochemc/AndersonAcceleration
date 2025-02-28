#!/bin/bash
#PBS -P xv83
#PBS -l ncpus=1
#PBS -l mem=60GB
#PBS -q copyq
#PBS -l walltime=00:30:00
#PBS -l wd
#PBS -l storage=scratch/xv83+scratch/public

SHARE_DIR=/scratch/public/bp3051/

mkdir ${SHARE_DIR}
rsync -a /scratch/xv83/bp3051/access-esm/archive/andersonacceleration_test-n10-5415f621/output007 ${SHARE_DIR}
rsync -a /scratch/xv83/bp3051/access-esm/archive/andersonacceleration_test-n10-5415f621/restart007 ${SHARE_DIR}
rsync -a /scratch/xv83/bp3051/access-esm/archive/andersonacceleration_test-n10-5415f621/restart008 ${SHARE_DIR}
rsync -a /home/561/bp3051/access-esm1.5/andersonacceleration_test ${SHARE_DIR}
rsync -a /scratch/xv83/bp3051/access-esm/work/andersonacceleration_test-n10-5415f621 ${SHARE_DIR}

chmod -R +rx ${SHARE_DIR}