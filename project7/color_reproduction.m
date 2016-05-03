%% Project 7: Color Reproduction. Team 14 (Jenee L & Justin P.)

%% Fetch ColorMunki XYZ and LAB data for color checker
%%Multiply munki XYZs by display model

colorMunkiData = importdata('munki_CC_XYZs_Labs.txt');
munkiXYZs = colorMunkiData(:,2:4);
munkiLABs = colorMunkiData(:,5:7);

cam_RGBs = importdata('cam_rgbs.mat');

fprintf('camera RGBs:\n');
disp(cam_RGBs);

%% Evaluate color error in model

dispModel = importdata('display_model.mat');

%Push through matrix model and conver to doubles
RGBCoords = derriveRGBs(munkiXYZs, dispModel);

%Scale RGB coordinates to a 0-100 range
RGBCoords = RGBCoords * (100/255);

dataSet = vertcat(RGBCoords, repmat(0,3,3), repmat(100,3,3));

dataReadings = [1:30; dataSet'];

%Write data to formatted ti1 file
writeTiFile('disp_model_test.ti1', dataReadings);

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
writeTiFile('workflow_test_uncal.ti1', dataReadings);

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



%% display relevant functions for report
dbtype('writeTiFile.m');
dbtype('derriveRGBs.m');
