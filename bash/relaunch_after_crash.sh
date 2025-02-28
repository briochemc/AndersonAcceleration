
# This script is a one-off that cleans up the output of ACCESS-ESM1.5 and submits a payu job.
# It essentially does the same as g_age.
# It was used to restart AA after a bug stopped my 11th cycle for some unknown reason (yet).
# Hopefully I archived everything to /scratch/xv83/bp3051/archive_restart_bug
# before running this script so I should be fine.

# Go to archive and remove output and restart files
cd /home/561/bp3051/access-esm1.5/andersonacceleration_test/archive
for foo in {000..009}; do
    rm -r restart$foo
    rm -r output$foo
done

# load payu, sweep, and submit job
cd /home/561/bp3051/access-esm1.5/andersonacceleration_test
conda deactivate
module use /g/data/vk83/modules
module load payu
module reload
payu --version
payu sweep
payu run -n 10