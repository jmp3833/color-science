%% Lab 6 - Display Characterization: Team 14 (Jenee Janglois & Justin Peterson)

%% Import Ramps Data

%Invoke professor provided script
run load_ramps_data_1516;

% Fetch largest XYZs for R G and B channels
MAX_XYZS = [ramp_R_XYZs(11,:);ramp_G_XYZs(11,:);ramp_B_XYZs(11,:)];

m_fwd = derive_fwd_matrix(MAX_XYZS, black_XYZ, white_XYZ);

%% Derrive forward LUTs

% Subtract black from red ramp XYZ values
red_sub_black = ramp_R_XYZs - repmat(black_XYZ,11,1);

%Normalize values by display white
red_sub_black = red_sub_black ./ repmat(white_XYZ,11,1); 

%Clip values outside the range of zero and one
red_sub_black(red_sub_black<0) = 0;
red_sub_black(red_sub_black>1) = 1;

%Multiply by inverse of first 3x3 of forward model
fwd_inv_three = m_fwd(:,1:3)';
est_RGB_radiometric_sclr = (red_sub_black * fwd_inv_three)';

ramp_R_RS = est_RGB_radiometric_sclr(1,:);

% define the 0-255 display values (digital counts) that correspond to the ramp values
ramp_DCs = round(linspace(0,255,11));
% interpolate the radiometric scalars across the full digital count range to form the forward LUTs
RLUT_fwd = interp1(ramp_DCs,ramp_R_RS(1,:),[0:1:255],'spline');

%% Blue Channel Forward LUTs

% Subtract black from red ramp XYZ values
blue_sub_black = ramp_B_XYZs - repmat(black_XYZ,11,1);

%Normalize values by display white
blue_sub_black = blue_sub_black ./ repmat(white_XYZ,11,1); 

%Clip values outside the range of zero and one
blue_sub_black(blue_sub_black<0) = 0;
blue_sub_black(blue_sub_black>1) = 1;

%Multiply by inverse of first 3x3 of forward model
fwd_inv_three = m_fwd(:,1:3)';
est_RGB_radiometric_sclr_B = (blue_sub_black * fwd_inv_three)';

ramp_B_BS = est_RGB_radiometric_sclr_B(3,:);

% define the 0-255 display values (digital counts) that correspond to the ramp values
ramp_DCs_B = round(linspace(0,255,11));
% interpolate the radiometric scalars across the full digital count range to form the forward LUTs
RLUT_fwd_B = interp1(ramp_DCs,ramp_B_BS(1,:),[0:1:255],'spline');

%% Green Channel Forward LUTs

% Subtract black from red ramp XYZ values
green_sub_black = ramp_R_XYZs - repmat(black_XYZ,11,1);

%Normalize values by display white
green_sub_black = green_sub_black ./ repmat(white_XYZ,11,1); 

%Clip values outside the range of zero and one
green_sub_black(green_sub_black<0) = 0;
green_sub_black(green_sub_black>1) = 1;

%Multiply by inverse of first 3x3 of forward model
fwd_inv_three = m_fwd(:,1:3)';
est_RGB_radiometric_sclr_G = (green_sub_black * fwd_inv_three)';

ramp_G_GS = est_RGB_radiometric_sclr_G(2,:);

% define the 0-255 display values (digital counts) that correspond to the ramp values
ramp_DCs_G = round(linspace(0,255,11));
% interpolate the radiometric scalars across the full digital count range to form the forward LUTs
RLUT_fwd_G = interp1(ramp_DCs_G,ramp_G_GS(1,:),[0:1:255],'spline');

%% Plot all LUTs

hold on;
plot(0:255,RLUT_fwd,0:255,RLUT_fwd_G,0:255,RLUT_fwd_B)
axis([0,255,0,1]);
