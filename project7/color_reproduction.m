%% Project 7: Color Reproduction. Team 14 (Jenee L & Justin P.)

%% Fetch ColorMunki XYZ and LAB data for color checker
%%Multiply munki XYZs by display model

colorMunkiData = importdata('munki_CC_XYZs_Labs.txt');
munkiXYZs = colorMunkiData(:,2:4);
munkiLABs = colorMunkiData(:,5:7);

cam_RGBs = importdata('cam_rgbs.mat');

dispModel = importdata('display_model.mat');

fprintf('camera RGBs:\n');
disp(cam_RGBs);

fprintf('Reverse Display Model:\n');
disp(dispModel);

%% Evaluate color error in model

%Push through matrix model and conver to doubles
RGBCoords = derriveRGBs(munkiXYZs, dispModel);

%Scale RGB coordinates to a 0-100 range
RGBCoords = RGBCoords * (100/255);

dataSet = vertcat(RGBCoords, repmat(0,3,3), repmat(100,3,3));

dataReadings = [1:30; dataSet'];

%Write data to formatted ti1 file
writeTiFile('data/disp_model_test.ti1', dataReadings);

%Load patch values into workspace
disp_XYZs = importdata('disp_model_test.ti3',' ',20); 

%Extract XYZ value for measured patches
munki_patch_XYZs = disp_XYZs.data(1:24,5:7);

%Generate averages of XYZ black and white values
disp_black = mean(disp_XYZs.data(25:27,5:7));
disp_white = mean(disp_XYZs.data(28:30,5:7));

display_labs = XYZ2Lab(munki_patch_XYZs',disp_white)';

%Generate delta EAB values for display vs colormunki readings
display_deltas = deltaEab(display_labs', munkiLABs');

%Construct display table of LAB values
step1_table = [munkiLABs, display_labs, display_deltas'];
step1_table = ([1:24; step1_table'])';

csvwrite('data/step1_out.csv', step1_table);

%% Uncalibrated color imaging workflow

%Fetch average RGBs of chart from project 5
% Using Readings from Jenee's 15" 2010 matte Macbook Pro

%Scale RGB values
cam_RGBs_scale = double(cam_RGBs);
cam_RGBs_scale = cam_RGBs_scale .* (100/255);

%Construct matrix to write to ti1 file for colormunki
dataSet = [cam_RGBs_scale, repmat(0,3,3),repmat(100,3,3)];
dataSet = [1:30;dataSet];

%Write data to formatted ti1 file
writeTiFile('data/workflow_test_uncal.ti1', dataReadings);

uncal_XYZs = importdata('workflow_test_uncal.ti3',' ',20);

%Extract XYZ value for measured patches
munki_patch_XYZs = uncal_XYZs.data(1:24,5:7);

%Generate averages of XYZ black and white values
disp_black = mean(uncal_XYZs.data(25:27,5:7));
disp_white = mean(uncal_XYZs.data(28:30,5:7));

display_labs = XYZ2Lab(munki_patch_XYZs',disp_white)';

%Generate delta EAB values for display vs colormunki readings
display_deltas = deltaEab(display_labs', munkiLABs');

%Construct display table of LAB values
step2_table = [munkiLABs, display_labs, display_deltas'];
step2_table = ([1:24; step2_table'])';

csvwrite('data/step2_out.csv', step2_table);

%% Find errors in color imaging workflow

%Estimate XYZs of patches via camera model

%Import lookup tables and forward matrix
RLUT_fwd = importdata('RLUT_fwd.mat');
GLUT_fwd = importdata('GLUT_fwd.mat');
BLUT_fwd = importdata('BLUT_fwd.mat');
M_fwd = importdata('M_fwd.mat');

cam_LUT_Results = zeros(3, 24);

% push the DCs through the forward LUTs to predict radiometric scalars
for i=1:size(cam_RGBs, 2)
    cam_LUT_Results(1,i) = RLUT_fwd(cam_RGBs(1,i)+1);
    cam_LUT_Results(2,i) = GLUT_fwd(cam_RGBs(2,i)+1);
    cam_LUT_Results(3,i) = BLUT_fwd(cam_RGBs(3,i)+1);
end

% add the homogeneous coordinate required to apply the forward matrix
cam_RSs_h = [cam_LUT_Results; ones(1,size(cam_LUT_Results,2))];

% apply the forward matrix to the RSs to calculate model-predicted XYZs 
modeled_XYZs = M_fwd * cam_RSs_h * 100;

%convert XYZs from D50 to D65
cie = loadCIEData();
D50_XYZ = ref2XYZ(cie.illE, cie.cmf2deg, cie.illD50); 	
D65_XYZ = ref2XYZ(cie.illE, cie.cmf2deg, cie.illD65);
modeled_XYZs = catBradford(modeled_XYZs, D50_XYZ, D65_XYZ);

%Pass new XYZs through display model to convert back to XYZs
modeled_RGBs = derriveRGBs(modeled_XYZs', dispModel);

%Rescale values into a 0-100 range
modeled_RGBs = modeled_RGBs .* (100/255);

%Construct matrix to write to ti1 file for colormunki
modeled_RGBs = [modeled_RGBs', repmat(0,3,3),repmat(100,3,3)];
modeled_RGBs = [1:30;modeled_RGBs];

%Write data to file to be parsed by colormunki
writeTiFile('data/workflow_test_cal.ti1', modeled_RGBs);

cal_XYZs = importdata('workflow_test_cal.ti3',' ',20); 

%Extract XYZ value for measured patches
munki_patch_XYZs = cal_XYZs.data(1:24,5:7);

%Generate averages of XYZ black and white values
disp_black = mean(cal_XYZs.data(25:27,5:7));
disp_white = mean(cal_XYZs.data(28:30,5:7));

display_labs = XYZ2Lab(munki_patch_XYZs',disp_white)';

%Generate delta EAB values for display vs colormunki readings
display_deltas = deltaEab(display_labs', munkiLABs');

%Construct display table of LAB values
step3_table = [munkiLABs, display_labs, display_deltas'];
step3_table = ([1:24; step3_table'])';

csvwrite('data/step3_out.csv', step3_table);

%% display relevant functions for report
dbtype('writeTiFile.m');
dbtype('derriveRGBs.m');
