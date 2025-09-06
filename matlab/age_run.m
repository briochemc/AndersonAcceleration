% BP: Modified restart.mat name (now AArestart.mat) and path to run this script from $HOME
% AArestart contains all the data for the Anderson acceleration script
% (This is **NOT** a restart file for the ACCESS model!)
scratchdir = '/scratch/xv83/bp3051';
inputdir = fullfile(scratchdir, 'AndersonAcceleration');
AArestartfile = fullfile(inputdir, 'AArestart.mat');

restartdir = fullfile(inputdir, 'restart');
initfile = fullfile(restartdir, 'ocean/ocean_age.res.nc');

if isfile(AArestartfile)
    fprintf('Using AArestartfile %s\n', AArestartfile)
    load(AArestartfile, 'aa');
else
    fprintf('Start from %s\n', initfile)
    wet3dfile = fullfile(inputdir, 'wet3d.mat');
    load(wet3dfile, 'wet3d');
    age3d = ncread(initfile, 'age_global');
    age_vec = age3d(wet3d);
    aa.x = age_vec;
end

% Anderson Acceleration parameters
AAparams.mMax = 10; % number of AA stored residuals % CHECK does it need be small?
AAparams.itmax = 50; % Number of AA iterates (if n-yr cycles this is n*itmax years)

% Anderson Acceleration history parameters
histParams.ncheckpointfreq = -1; % Turn off checkpoint saves

[xsol, iter, aa] = AndersonAcceleration(@g_age, aa.x, AAparams, histParams, AArestartfile);

