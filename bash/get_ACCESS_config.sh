# Following https://access-hive.org.au/models/run-a-model/run-access-esm/#get-access-esm15-configuration
# but for the historical rather than preindustrial
# and naming my branch AA_ideal_age for "Anderson Accelerated ideal age"

mkdir -p ~/access-esm1.5
cd ~/access-esm1.5
payu clone -b AA_ideal_age -B release-historical+concentrations https://github.com/ACCESS-NRI/access-esm1.5-configs historical+concentrations

# To change directory to control directory run:

cd historical+concentrations