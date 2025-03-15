#!/bin/bash
#PBS -P xv83
#PBS -l ncpus=1
#PBS -l mem=30GB
#PBS -q copyq
#PBS -l walltime=03:00:00
#PBS -l wd
#PBS -l storage=scratch/xv83

SAVEDIR=/scratch/xv83/bp3051/crash3
CONTROL_DIR=${SAVEDIR}/control
WORK_DIR=${SAVEDIR}/work
ARCHIVE_DIR=${SAVEDIR}/archive

mkdir -p ${CONTROL_DIR}
mkdir -p ${WORK_DIR}
mkdir -p ${ARCHIVE_DIR}

rsync -a /home/561/bp3051/access-esm1.5/andersonacceleration_test ${CONTROL_DIR}
rsync -a /scratch/xv83/bp3051/access-esm/work/andersonacceleration_test-n10-5415f621 ${WORK_DIR}
rsync -a /scratch/xv83/bp3051/access-esm/archive/andersonacceleration_test-n10-5415f621 ${ARCHIVE_DIR}

chmod -R +rx ${SAVEDIR}