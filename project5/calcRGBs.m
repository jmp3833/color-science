%% Calculate normalized RGB values Justin Peterson && Jenee Lanlois (Team 14)


% Using Readings from Jenee's 15" 2010 matte Macbook Pro

%Manual entry of RGB values taken from photoshop
cam_RGBs = [101,71,57;216,166,143;98,127,169;82,108,63;148,140,197;...
    120,219,199;216,120,44;57,73,160;214,88,100;82,42,95;169,213,74;...
    242,184,61;29,33,124;55,140,66;188,42,57;245,229,63;206,75,153;...
    31,129,166;233,238,232;194,200,196;151,153,152;105,109,108;...
    62,63,65;31,32,36]';

%Normalize RGB values
cam_RGBs = cam_RGBs./255;
fprintf('cam_RGBs = \n');
disp(cam_RGBs);

%Grab final 'row' of RGB values for colorchecer chart
%Sort from black to white
cam_gray_rgbs = cam_RGBs(:,19:24);
cam_gray_rgbs = fliplr(cam_gray_rgbs);
fprintf('cam_gray_rgbs = \n');
disp(cam_gray_rgbs);

%% Lab Step 4 - Calculate normalized Y values
%Calculate normalized Y values for patches 19-24 
munki_values = importdata('munki_CC_XYZs_Labs.txt');
munki_gray_Ys = fliplr(munki_values(19:24,3)'./100);

fprintf('munki_gray_Ys = \n');
disp(munki_gray_Ys);


%% Graph RGB Versus Grey Y values
clf;
hold on;
plot(munki_gray_Ys, cam_gray_rgbs(1,:));
plot(munki_gray_Ys, cam_gray_rgbs(2,:));
plot(munki_gray_Ys, cam_gray_rgbs(3,:));
title('original greyscale Y to RGB relationship');
xlabel('munki gray Ys');
ylabel('camera grey RGBs');
hold off;

%% Linearize Camera RGB Output and Plot

r = 1; g = 2; b = 3;
% fit low-order polynomial functions between the camera gray rgbs
% and the munki gray Ys
cam_polys(r,:)=polyfit(cam_gray_rgbs(r,:),munki_gray_Ys,3);
cam_polys(g,:)=polyfit(cam_gray_rgbs(g,:),munki_gray_Ys,3);
cam_polys(b,:)=polyfit(cam_gray_rgbs(b,:),munki_gray_Ys,3);

% use the functions to linearize the camera RGB data
cam_rgbs_lin(r,:) = polyval(cam_polys(r,:),cam_RGBs(r,:));
cam_rgbs_lin(g,:) = polyval(cam_polys(g,:),cam_RGBs(g,:));
cam_rgbs_lin(b,:) = polyval(cam_polys(b,:),cam_RGBs(b,:));

% clip out of range values
cam_rgbs_lin(cam_rgbs_lin<0) = 0;
cam_rgbs_lin(cam_rgbs_lin>1) = 1;

% Fetch gray values of linearized cam RGBs
cam_rgbs_gray_lin = fliplr(cam_rgbs_lin(:,19:24));

clf;
hold on;
plot(munki_gray_Ys, cam_rgbs_gray_lin(1,:));
plot(munki_gray_Ys, cam_rgbs_gray_lin(2,:));
plot(munki_gray_Ys, cam_rgbs_gray_lin(3,:));
title('linearized greyscale Y to RGB relationship');
xlabel('munki gray Ys');
ylabel('linearized camera grey RGBs');
hold off;

%% Camera RGB Visualization

% visualize the original camera RGBs
pix = permute(cam_RGBs, [3 2 1]);
pix = reshape(pix, [6 4 3]);
pix = imrotate(pix, -90);
pix = flipdim(pix,2);
figure;
image(pix);
title('original camera patch RGBs');

% visualize the linearized camera RGBs
pix = permute(cam_rgbs_lin, [3 2 1]);
pix = reshape(pix, [6 4 3]);
pix = imrotate(pix, -90);
pix = flipdim(pix,2);
figure;
image(pix);
title('linearized camera patch RGBs');

%% Derive 3x3 Transformation Matrix

% use the linearized camera rgbs and munki-measured XYZs
% to derive an rgb to XYZ transformation matrix
% pinv finds the matrix that provides the a least squares
% linear solution for relating the rgbs and XYZs
munki_data = importdata('munki_CC_XYZs_Labs.txt');
munki_XYZs = munki_data(:,2:4)';
cam_matrix = munki_XYZs * pinv(cam_rgbs_lin);

fprintf('cam_matrix = \n');
disp(cam_matrix);

% estimate the CC XYZs from the linearized camera rgbs using
% the camera model matrix
cam_XYZs = cam_matrix * cam_rgbs_lin;

fprintf('cam_XYZs = \n');
disp(cam_XYZs);

%% Calculate CIELab and DeltaEAB of ColorChecker for Estimated XYZs

cie = loadCIEData();
XYZn_D50 = ref2XYZ(cie.illE,cie.cmf2deg,cie.illD50);
RGB_Labs = XYZ2Lab(cam_XYZs, XYZn_D50);

ColorMunki_CieLabs = munki_data(:, 5:7)';

deltas = deltaEab(RGB_Labs, ColorMunki_CieLabs);

%% Visualize using chromatic adaptation

XYZ_D50 = ref2XYZ(cie.illE,cie.cmf2deg,cie.illD50);
XYZ_D65 = ref2XYZ(cie.illE,cie.cmf2deg,cie.illD65);

% visualize ColorMunki XYZs in sRGB

munki_XYZs_D65 = catBradford(munki_XYZs, XYZ_D50, XYZ_D65);
munki_XYZs_sRGBs = XYZ2sRGB(munki_XYZs_D65);
pix = reshape(munki_XYZs_sRGBs', [6 4 3]);
pix = uint8(pix*255);
pix = imrotate(pix, -90);
pix = flipdim(pix,2);
figure;
image(pix);
title('munkiXYZs chromatically adapted and visualized in sRGB');

% visualize camera-estimated XYZs in sRGB

cam_XYZs_D65 = catBradford(cam_XYZs, XYZ_D50, XYZ_D65);
cam_XYZs_sRGBs = XYZ2sRGB(cam_XYZs_D65);
pix = reshape(cam_XYZs_sRGBs', [6 4 3]);
pix = uint8(pix*255);
pix = imrotate(pix, -90);
pix = flipdim(pix,2);
figure;
image(pix);
title('estimatedXYZs chromatically adapted and visualized in sRGB');

%% save  camera characterization model

save('camera_model.mat', 'cam_polys', 'cam_matrix');

%% Calc Estimated Patch LABs

%Patch RGB values read from patch 16.1 and 16.2
patch_RGBs = [120,54,42;69,41,38]'./255;

% use the functions to linearize the camera RGB data
patch_rgbs_lin(r,:) = polyval(cam_polys(r,:),patch_RGBs(r,:));
patch_rgbs_lin(g,:) = polyval(cam_polys(g,:),patch_RGBs(g,:));
patch_rgbs_lin(b,:) = polyval(cam_polys(b,:),patch_RGBs(b,:));

% clip out of range values
patch_rgbs_lin(patch_rgbs_lin<0) = 0;
patch_rgbs_lin(patch_rgbs_lin>1) = 1;

cam_est_patch_XYZs = cam_matrix * patch_rgbs_lin;

%Calculate LAB Values with D50 ref illuminant
patch_LABs = XYZ2Lab(cam_est_patch_XYZs, XYZn_D50);

%Values measured in project 2, step 2 for
%real patch LAB values (16.1,%16.2)
calced_ColorMunki_Lab = ...
    [36.683077,27.123596,22.611685;28.408574,14.193084,9.377987]';

patchDeltas = deltaEab(patch_LABs,calced_ColorMunki_Lab);

%% Display estimated patches

% visualize Cam XYZs in sRGB for patches 16.1 and 16.2
% Figures commented out in lieu of screenshots to compare patch image with
% the two other rendered images.

cam_patch_XYZs_D65 = catBradford(cam_est_patch_XYZs, XYZ_D50, XYZ_D65);
cam_patch_XYZs_sRGBs = XYZ2sRGB(cam_patch_XYZs_D65);
pix = reshape(cam_patch_XYZs_sRGBs', [2 1 3]);
pix = uint8(pix*255);
pix = flipdim(pix,2);
%figure;
%image(pix);
title('cam XYZs chromatically adapted and visualized in sRGB (patch 16.1 - 16.2)');

% visualize camera-estimated XYZs in sRGB
measured_patch_XYZs = ...
    [12.671117,9.367839,3.273952;6.704818,5.610822,3.127515]'

munki_XYZs_D65 = catBradford(measured_patch_XYZs, XYZ_D50, XYZ_D65);
munki_XYZs_sRGBs = XYZ2sRGB(munki_XYZs_D65);
pix = reshape(munki_XYZs_sRGBs', [2 1 3]);
pix = uint8(pix*255);
pix = flipdim(pix,2);
%figure;
%image(pix);
title('munki XYZs chromatically adapted and visualized in sRGB (patch 16.1 - 16.2)');