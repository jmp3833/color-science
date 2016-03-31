%% Calculate normalized RGB values
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
cam_grey_rgbs = cam_RGBs(:,19:24);
cam_grey_rgbs = fliplr(cam_grey_rgbs);
fprintf('cam_grey_rgbs = \n');
disp(cam_grey_rgbs);

%% Lab Step 4 - Calculate normalized Y values
%Calculate normalized Y values for patches 19-24 
munki_values = importdata('munki_CC_XYZs_Labs.txt');
munki_gray_Ys = fliplr(munki_values(19:24,3)'./100);

fprintf('munki_gray_Ys = \n');
disp(munki_gray_Ys);


%% Graph RGB Versus Grey Y values
clf;
hold on;
plot(munki_gray_Ys, cam_grey_rgbs(1,:));
plot(munki_gray_Ys, cam_grey_rgbs(2,:));
plot(munki_gray_Ys, cam_grey_rgbs(3,:));
title('original greyscale Y to RGB relationship');
xlabel('munki gray Ys');
ylabel('camera grey RGBs');

hold off;