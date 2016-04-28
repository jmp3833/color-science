%% Lab 6 - Display Characterization: Team 14 (Jenee Langlois & Justin Peterson)

%% Import Ramps Data

%Invoke professor provided script
run load_ramps_data_1516;

% Fetch largest XYZs for R G and B channels
MAX_XYZS = [ramp_R_XYZs(11,:);ramp_G_XYZs(11,:);ramp_B_XYZs(11,:)];

M_fwd = derive_fwd_matrix(MAX_XYZS, black_XYZ, white_XYZ);

%% Derrive forward LUTs

Yw = white_XYZ(2);

% Subtract black from red ramp XYZ values
red_sub_black = ramp_R_XYZs - repmat(black_XYZ,11,1);

%Normalize values by display white
red_sub_black = red_sub_black ./ Yw; 

%Multiply by inverse of first 3x3 of forward model
fwd_inv_three = inv(M_fwd(:,1:3));
est_RGB_radiometric_sclr = fwd_inv_three * red_sub_black';

%Clip values outside the range of zero and one
red_sub_black(red_sub_black<0) = 0;
red_sub_black(red_sub_black>1) = 1;

ramp_R_RS = est_RGB_radiometric_sclr(1,:);

% define the 0-255 display values (digital counts) that correspond to the ramp values
ramp_DCs = round(linspace(0,255,11));
% interpolate the radiometric scalars across the full digital count range to form the forward LUTs
RLUT_fwd = interp1(ramp_DCs,ramp_R_RS,[0:1:255],'spline');

%% Blue Channel Forward LUTs

% Subtract black from red ramp XYZ values
blue_sub_black = ramp_B_XYZs - repmat(black_XYZ,11,1);

%Normalize values by display white
blue_sub_black = blue_sub_black ./ Yw; 

%Multiply by inverse of first 3x3 of forward model
fwd_inv_three = inv(M_fwd(:,1:3));
est_RGB_radiometric_sclr_B = fwd_inv_three * blue_sub_black';

%Clip values outside the range of zero and one
blue_sub_black(blue_sub_black<0) = 0;
blue_sub_black(blue_sub_black>1) = 1;

ramp_B_BS = est_RGB_radiometric_sclr_B(3,:);

% define the 0-255 display values (digital counts) that correspond to the ramp values
ramp_DCs_B = round(linspace(0,255,11));
% interpolate the radiometric scalars across the full digital count range to form the forward LUTs
BLUT_fwd = interp1(ramp_DCs,ramp_B_BS,[0:1:255],'spline');

%% Green Channel Forward LUTs

% Subtract black from red ramp XYZ values
green_sub_black = ramp_G_XYZs - repmat(black_XYZ,11,1);

%Normalize values by display white
green_sub_black = green_sub_black ./ Yw; 

%Multiply by inverse of first 3x3 of forward model
fwd_inv_three = inv(M_fwd(:,1:3));
est_RGB_radiometric_sclr_G = fwd_inv_three * green_sub_black';

%Clip values outside the range of zero and one
green_sub_black(green_sub_black<0) = 0;
green_sub_black(green_sub_black>1) = 1;

ramp_G_GS = est_RGB_radiometric_sclr_G(2,:);

% define the 0-255 display values (digital counts) that correspond to the ramp values
ramp_DCs_G = round(linspace(0,255,11));
% interpolate the radiometric scalars across the full digital count range to form the forward LUTs
GLUT_fwd = interp1(ramp_DCs_G,ramp_G_GS,[0:1:255],'spline');

%% Plot all LUTs

hold on;
plot(0:255,RLUT_fwd, 0:255, GLUT_fwd, 0:255, BLUT_fwd);
axis([0,255,0,1]);
title('Forward Model LUTs');
xlabel('Digital counts RGB 0-255');
ylabel('radiometric scalars RGB 0-1');

%% Test quality of forward model
run test_forward_model_1516;

%% Generare reverse display matrix

%inverse of the first three columns of the forward column matrix
M_rev = inv(M_fwd(:,1:3));
fprintf('M_rev = \n')
disp(M_rev);

% build the reverse LUT for the red channel
RLUT_rev = round(interp1(RLUT_fwd, 0:255, linspace(0,max(RLUT_fwd),1024), 'spline', 0));

% repeat for green and blue
GLUT_rev = round(interp1(GLUT_fwd, 0:255, linspace(0,max(GLUT_fwd),1024), 'spline', 0));
BLUT_rev = round(interp1(BLUT_fwd, 0:255, linspace(0,max(BLUT_fwd),1024), 'spline', 0));

%% Save and plot final display model

M_disp = M_rev;
XYZk = black_XYZ;
XYZk_disp = XYZk;
RLUT_disp = RLUT_rev;
GLUT_disp = GLUT_rev;   
BLUT_disp = BLUT_rev;

% save the reverse model matrix, reverse LUTs as and black level as 'display_model.mat'
 save('display_model.mat','M_disp','RLUT_disp','GLUT_disp','BLUT_disp','XYZk_disp');
 
%% Display Reverse Matrix content

fprintf('M_disp = M_rev = \n');
disp(M_rev);

fprintf('XYZk_disp = XYZk = \n');
disp(XYZk);
 
%% Print relevant functions
dbtype('derive_fwd_matrix.m');

clf;
hold on;
plot(0:1023,RLUT_rev,0:1023,GLUT_rev,0:1023,BLUT_rev);
axis([0,1024,0,250]);
title('reverse model LUTs');
xlabel('scaled/quantized radiometric scalars RGB 0-1023');
ylabel('digital counts RGB 0-255');
hold off;

%% Test reverse display model

cie = loadCIEData();
D50_XYZ = ref2XYZ(cie.illE, cie.cmf2deg, cie.illD50); 	
D65_XYZ = ref2XYZ(cie.illE, cie.cmf2deg, cie.illD50);

Munki_Patch_XYZs = importdata('munki_CC_XYZs_Labs.txt');
Munki_Patch_XYZs = Munki_Patch_XYZs(:,2:4);

adapt_XYZs = catBradford(Munki_Patch_XYZs',D50_XYZ, D65_XYZ);

% Subtract XYZ black from each adapted value
adapt_XYZs = adapt_XYZs' - repmat(black_XYZ,24,1);

%Multiply by matrix to obtain radiometric scalars
scalars = adapt_XYZs * M_disp;

% Normalize scalars by 100
scalars = scalars./100;

% Clip any out of range values
scalars(scalars<0) = 0;
scalars(scalars>1) = 1;

%Multiply scalars by 1023 and round to nearest integer
scalars = round(scalars * 1023) + 1;

%Index into appropriate lookup tables
R_LUT_RESULT = RLUT_rev(scalars);
G_LUT_RESULT = GLUT_rev(scalars);
B_LUT_RESULT = BLUT_rev(scalars);

result_RGBs = [R_LUT_RESULT(:,1) G_LUT_RESULT(:,2) B_LUT_RESULT(:,3)];

% Convert to 8 bit unsigned integers
R_LUT_RESULT = uint8(RLUT_rev(scalars(:,1)))';
G_LUT_RESULT = uint8(GLUT_rev(scalars(:,2)))';
B_LUT_RESULT = uint8(BLUT_rev(scalars(:,3)))';

result = [R_LUT_RESULT G_LUT_RESULT B_LUT_RESULT];
pix = reshape(result,[6,4,3]);
pix = imrotate(pix, -90);
pix = flip(pix, 2);

figure;
image(pix);

title('colorchecker rendered from the measured XYZs using hte display model');

%% Evaluate Model Quality
 
% push the model-calculated digital counts from the previous step through 
% the forward LUTs to calculate radiometric scalars

result = result';
for i=1:size(result,2)
    est_patch_RSs(1,i) = RLUT_fwd(result(1,i)+1);
    est_patch_RSs(2,i) = GLUT_fwd(result(2,i)+1);
    est_patch_RSs(3,i) = BLUT_fwd(result(3,i)+1);
end
 
% add the homogeneous coordinate to the RSs
est_patch_RSs_h = [est_patch_RSs; ones(1,size(est_patch_RSs,2))];
 
% push the RSs through the forward model matrix to calculate XYZs
result_XYZs = M_fwd * est_patch_RSs_h * 100;

%Map XYZ values over to D50 reference illuminant
result_XYZs = catBradford(result_XYZs,D65_XYZ,D50_XYZ);

%Convert to LAB values from XYZ values
result_LABs = XYZ2Lab(result_XYZs,D50_XYZ);
colorMunki_LABs = importdata('munki_CC_XYZs_Labs.txt');
colorMunki_LABs = colorMunki_LABs(:,5:7);

lab_deltas = deltaEab(result_LABs, colorMunki_LABs');



