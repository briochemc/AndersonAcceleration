
% Load the salt restart file to make the mask of wet points
salt = ncread('/g/data/vk83/experiments/inputs/access-esm1p5/modern/historical/restart/ocean/ocean_temp_salt.res.nc', 'salt');
wet3d = salt > 0;

% and save it
scratchdir = '/scratch/xv83/bp3051';
inputdir = fullfile(scratchdir, 'AndersonAcceleration');
wet3dfile = fullfile(inputdir, 'wet3d.mat');

system("mkdir -p " + inputdir);
save(wet3dfile, 'wet3d');
