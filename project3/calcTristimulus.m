% load the CIE observer and illuminant data
% define ColorMunki/Argyll/spotread measurement wavelengths for the
% normal and transmissive (-t) modes

%Note: an alternative importSP script was created since our SP files were
%stored in a different format. 

%Populate CIE Struct
cie = loadCIEData()

cm_lams_norm = 410:10:730;
cm_lams_trans = 380:10:730;

% define header offsets for reading the .sp files
cm_h_offset_norm = 54;
cm_h_offset_trans = 57;

% load and normalize the measured spectral data for the patch #1
data = importSP('161.sp');
real_161 = data/100;
data = importSP('161-imaged.sp');
imaged_161 = data/100;
data = importSP('161-created.sp');
matching_161 = data/100;

% repeat the section above for patch #2
data = importSP('162.sp');
real_162 = data/100
data = importSP('162-imaged.sp');
imaged_162 = data/100;
data = importSP('162-created.sp');
matching_162 = data/100;

%Interpolate XYZ calculated data 
real161_interp = interp1(cm_lams_trans, real_161, cie.lambda(:),'linear','extrap');
imaged161_interp = interp1(cm_lams_trans, imaged_161, cie.lambda(:),'linear','extrap');
matching161_interp = interp1(cm_lams_trans, matching_161, cie.lambda(:),'linear','extrap');

real162_interp = interp1(cm_lams_trans, real_162, cie.lambda(:),'linear','extrap');
imaged162_interp = interp1(cm_lams_trans, imaged_162, cie.lambda(:),'linear','extrap');
matching162_interp = interp1(cm_lams_trans, matching_162, cie.lambda(:),'linear','extrap');

%Slear open figure windows
clf()

%Graph patch of 16-1 for interpolated and regular measurement
hold on
plot(cie.lambda,real161_interp);
plot(cie.lambda,imaged161_interp);
plot(cie.lambda,matching161_interp);

plot(cm_lams_trans,real_161, '-.*');
plot(cm_lams_trans,imaged_161, '-.*');
plot(cm_lams_trans,matching_161, '-.*');

axis([350 800 0 1])
xlabel('wavelength(nm)')
ylabel('reflectance factor')

legend('real interpolated', 'imaged interpolated', 'matching interpolated',...
    'real measured', 'imaged measured', 'matching measured')

title('Patch 16.1: measured and interpolated spectra')
set(gca,'fontsize', 18);

figure()

%...And the same for patch 16.2
hold on
plot(cie.lambda,real162_interp);
plot(cie.lambda,imaged162_interp);
plot(cie.lambda,matching162_interp);

plot(cm_lams_trans,real_162, '-.*');
plot(cm_lams_trans,imaged_162, '-.*');
plot(cm_lams_trans,matching_162, '-.*');

axis([350 800 0 1])
xlabel('wavelength(nm)')
ylabel('reflectance factor')

legend('real interpolated', 'imaged interpolated', 'matching interpolated',...
    'real measured', 'imaged measured', 'matching measured')
title('Patch 16.2: measured and interpolated spectra')

set(gca,'fontsize', 18);

