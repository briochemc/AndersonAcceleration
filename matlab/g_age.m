function [gx, gv, vnorms, externalconv] = g_age(x, fetchOutput, iter)

% BP: Modified paths
payudir    = '/home/561/bp3051/access-esm1.5/andersonacceleration_test';
archivedir = '/home/561/bp3051/access-esm1.5/andersonacceleration_test/archive';
inputdir   = '/scratch/xv83/bp3051/AndersonAcceleration';
restartdir = '/scratch/xv83/bp3051/AndersonAcceleration/restart';

% BP: number of years per cycle. Modify to 10 to match 1850s age.
yearspercycle = 10;

outfile = fullfile(archivedir, sprintf('restart%03d', yearspercycle - 1), 'ocean', 'ocean_age.res.nc');
infile = fullfile(restartdir, 'ocean', 'ocean_age.res.nc');
age_outdir = fullfile(archivedir, 'age_output');
system("mkdir -p " + age_outdir);

load(fullfile(inputdir, 'wet3d.mat'), 'wet3d');

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
    age_out = x;
    age_out3d = zeros(size(wet3d));
    age_out3d(wet3d) = age_out;
    if iter == 0
        copyfile(infile, backup);
    else
        copyfile(outfile, backup);
        copyfile(outfile, infile);

        % need to get rid of checksum to restart with new age tracer
        ncid = netcdf.open(infile, 'NC_WRITE');
        varid = netcdf.inqVarID(ncid, 'age_global');
        netcdf.renameAtt(ncid,varid,'checksum', 'old');
        netcdf.close(ncid);
        ncwrite(infile, 'age_global', age_out3d);
    end
    cd (archivedir);
    % if exist('restart001')
    for year = 1:yearspercycle
        % !rm -r restart001 output001
        system(sprintf("rm -r restart%03d", year - 1));
        system(sprintf("rm -r output%03d", year - 1));
    end
    cd (payudir);
    % CHECK that I run the right payu command here
    !module use /g/data/vk83/modules
    !module load payu
    !module reload
    !payu --version
    !payu sweep
    system(sprintf("payu run -n %i", yearspercycle));
end

vnorms = [];
externalconv = [];
gv = [];

end
