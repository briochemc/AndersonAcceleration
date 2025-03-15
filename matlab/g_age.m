function [gx, gv, vnorms, externalconv] = g_age(x, fetchOutput, iter)

% BP: Modified paths
payu_dir    = '/home/561/bp3051/access-esm1.5/andersonacceleration_test';
archive_dir = '/home/561/bp3051/access-esm1.5/andersonacceleration_test/archive';
input_dir   = '/scratch/xv83/bp3051/AndersonAcceleration';
restart_dir = '/scratch/xv83/bp3051/AndersonAcceleration/restart';

% BP: number of years per cycle. Modify to 10 to match 1850s age.
yearspercycle = 10;

outfile = fullfile(archive_dir, sprintf('restart%03d', yearspercycle - 1), 'ocean', 'ocean_age.res.nc');
cycle_restart_age_file = fullfile(restart_dir, 'ocean', 'ocean_age.res.nc');
age_outdir = fullfile(archive_dir, 'age_output');
system("mkdir -p " + age_outdir);

load(fullfile(input_dir, 'wet3d.mat'), 'wet3d');

if fetchOutput
    fprintf('getting data from %s \n', outfile)
    if ~isfile(outfile)
        error("No more file there!")
    end
    age3d = ncread(outfile, 'age_global');
    gx = age3d(wet3d);
else
    fprintf('submit model run for iter = %d\n', iter)
    backup = fullfile(age_outdir, sprintf('ocean_age.res_%04d.nc', iter));
    accelerated_age = x;
    accelerated_age3d = zeros(size(wet3d));
    accelerated_age3d(wet3d) = accelerated_age;
    if iter == 0
        copyfile(cycle_restart_age_file, backup);
    else
        copyfile(outfile, backup);
        % Also copy age at start of cycle!
        cycle_restart_backup_file = fullfile(age_outdir, sprintf('ocean_age.cyclestart_%04d.nc', iter));
        copyfile(cycle_restart_age_file, cycle_restart_backup_file);
        copyfile(outfile, cycle_restart_age_file);
        % BP Not sure the line above is needed since this restart file should already exist
        % And its content is modified just below. Leaving it for now as I don't want to break anything

        % need to get rid of checksum to restart with new age tracer
        ncid = netcdf.open(cycle_restart_age_file, 'NC_WRITE');
        varid = netcdf.inqVarID(ncid, 'age_global');
        netcdf.renameAtt(ncid,varid,'checksum', 'old');
        netcdf.close(ncid);
        ncwrite(cycle_restart_age_file, 'age_global', accelerated_age3d);
    end
    cd (archive_dir);
    % if exist('restart001')
    for year = 1:yearspercycle
        % !rm -r restart001 output001
        system(sprintf("rm -r restart%03d", year - 1));
        system(sprintf("rm -r output%03d", year - 1));
    end
    cd (payu_dir);
    % CHECK that I run the right payu command here
    % system("module use /g/data/vk83/modules")
    % system("module load payu")
    % system("module reload")
    system("payu --version")
    system("payu sweep")
    system(sprintf("payu run -n %i", yearspercycle));
    % module use /g/data/vk83/modules
    % module load payu
    % module reload
    % payu --version
    % payu sweep
    % payu run -n 10
end

vnorms = [];
externalconv = [];
gv = [];

end
