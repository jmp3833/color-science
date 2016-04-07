% load_ramps_data.m
% parse the ramps_plus.ti3 file and load the measured XYZ data into the
% workspace
% 11/6/13 jaf

% read in the Argyll ramp data
% unscramble the data file and extract the blacks, whites, and ramps data
ramps = importdata('ramps_plus.ti3',' ',29);

% housekeeping, don't look
ramps_sorted = sortrows(ramps.data(:,2:7),[1 2 3]);
mixed = ramps_sorted(25:end-4,:);
mixed_sorted = sortrows(mixed, [2 3]);
ramps_sorted_XYZs = ramps_sorted(:,4:6);
mixed_sorted_XYZs = mixed_sorted(:,4:6);

% get the measured XYZs for the display black and white
black_XYZ = mean(ramps_sorted_XYZs(1:4,:));
white_XYZ = mean(ramps_sorted_XYZs(end-3:end,:));

% get the measured XYZs for the R,G,B, and neutral (N) ramps
ramp_R_XYZs = [black_XYZ; mixed_sorted_XYZs(1:1+9, :)];
ramp_B_XYZs = [black_XYZ; ramps_sorted_XYZs(5:5+9,:)];
ramp_G_XYZs = [black_XYZ; ramps_sorted_XYZs(15:15+9,:)];
ramp_N_XYZs = [black_XYZ; mixed_sorted_XYZs(11:end, :); white_XYZ];
