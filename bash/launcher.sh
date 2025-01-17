# This script is supposedly the initial laucnher for the entire AA process to run
# It sets up the ACCESS model, copies the config file, etc.

# For ACCESS-ESM1.5 docs see https://access-hive.org.au/models/run-a-model/run-access-esm/#get-access-esm15-configuration
# Here I used the historical rather than preindustrial

# Load payu and check version:
module use /g/data/vk83/modules
module load payu
module reload
payu --version
# Note: payu version must be greater than 1.1.5,
# (I load the latest Gadi version in my `~/.bash_profile`, but,
# TODO here I use module reload because for some reason it doen't execute what's loaded?!)

# FIXME this below should be the only thing left I guess?
# # If it's the first time I am running this I need to clone the setup I think
# mkdir -p ~/access-esm1.5
# cd ~/access-esm1.5
# payu clone -b test2 -B release-historical+concentrations https://github.com/ACCESS-NRI/access-esm1.5-configs andersonacceleration_test

# otherwise I just get in and checkout a new branch
payudir=~/access-esm1.5/andersonacceleration_test
cd ${payudir}
payu checkout test3

# I then copy my ACCESS-ESM1.5 config file to the payu dir
cp ~/Projects/AndersonAcceleration/payu/config.yaml ${payudir}/config.yaml

# Copy default historical restart files into a directory that I can edit (so that I can update the 1850 Jan 1 age)
cp -r /g/data/vk83/configurations/inputs/access-esm1p5/modern/historical/restart /scratch/xv83/bp3051/AndersonAcceleration/

# Clean up everything in the archive etc.
# payu sweep
payu sweep --hard # careful with that!
# Clean up the AArestart file
rm /scratch/xv83/bp3051/AndersonAcceleration/AArestart.mat

# And start the whole Anderson Acceleration process by running the model
# payu run -n 2
# Alternatively, just start with do_anderson like David intended
qsub ~/Projects/AndersonAcceleration/payu/do_anderson.sh

# Just so that I cd back
cd ~/Projects/AndersonAcceleration




