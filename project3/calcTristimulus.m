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
real_162 = data/100;
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

%Calculate xyz values for real imaged and matching patches
xyz161RealCalc = ref2XYZ(real161_interp, cie.cmf2deg, cie.illD50);
xyz161ImagedCalc = ref2XYZ(imaged161_interp, cie.cmf2deg, cie.illD50);
xyz161MatchingCalc = ref2XYZ(matching161_interp, cie.cmf2deg, cie.illD50);
xyz162RealCalc = ref2XYZ(real162_interp, cie.cmf2deg, cie.illD50);
xyz162ImagedCalc = ref2XYZ(imaged162_interp, cie.cmf2deg, cie.illD50);
xyz162MatchingCalc = ref2XYZ(matching162_interp, cie.cmf2deg, cie.illD50);

%Manual data entry for the measured XYZ values of real, imaged, and
%patching swatches.

xyz161Real = [12.671117 9.367839  3.273952];
xyz161Imaged = [27.885365 18.360140 5.827478];
xyz161Matching = [9.108034  5.936318  0.878260]; 
xyz162Real = [6.704818  5.610822  3.127515]; 
xyz162Imaged = [7.878567  5.511291  2.580699];
xyz162Matching = [2.648019  1.806134  0.354015];

%Calculate xyY values for measured and calculated XYZ values for both
%patches

xyY161RealCalc = XYZ2xyY(xyz161RealCalc(1),xyz161RealCalc(2),xyz161RealCalc(3));
xyY161ImagedCalc = XYZ2xyY(xyz161ImagedCalc(1),xyz161ImagedCalc(2),xyz161ImagedCalc(3));
xyY161MatchingCalc = XYZ2xyY(xyz161MatchingCalc(1),xyz161MatchingCalc(2),xyz161MatchingCalc(3));
xyY162RealCalc = XYZ2xyY(xyz162RealCalc(1),xyz162RealCalc(2),xyz162RealCalc(3));
xyY162ImagedCalc = XYZ2xyY(xyz162ImagedCalc(1),xyz162ImagedCalc(2),xyz162ImagedCalc(3));
xyY162MatchingCalc = XYZ2xyY(xyz162MatchingCalc(1),xyz162MatchingCalc(2),xyz162MatchingCalc(3));

xyY161Real = XYZ2xyY(xyz161Real(1),xyz161Real(2),xyz161Real(3));
xyY161Imaged = XYZ2xyY(xyz161Imaged(1),xyz161Imaged(2),xyz161Imaged(3));
xyY161Matching = XYZ2xyY(xyz161Matching(1),xyz161Matching(2),xyz161Matching(3));
xyY162Real = XYZ2xyY(xyz162Real(1),xyz162Real(2),xyz162Real(3));
xyY162Imaged = XYZ2xyY(xyz162Imaged(1),xyz162Imaged(2),xyz162Imaged(3));
xyY162Matching = XYZ2xyY(xyz162Matching(1),xyz162Matching(2),xyz162Matching(3));

% plot_chrom_diag_skel.m
% plot the skeleton of the chromaticity diagram, with spectral locus and
% major illuminants
% requires a new blank figure and the loadCIEdata and XYZ2xyY functions
% 2/24/16 jaf

% load the CIE observer and illuminant data
cie = loadCIEData;

% create a new figure with hold on and line_width = 1.5
figure;
hold on;
line_weight = 1.5;

set(gca, 'FontSize', 14);
set(gca, 'LineWidth', line_weight);
axis('equal'); % make plot scales equal
axis([0,0.9,0,0.9]); % set the axis ranges
xlabel('x');
ylabel('y');

% set the min and max for each axis of the plot
axis([0 0.9 0 0.9],'xy');

% force the tick spacing of the plot to be 0.3 on the X axis
set(gca, 'XTick', 0:0.3:0.9);
set(gca, 'XTickLabel', [ 0:0.3:0.9 ] );

% force the tick spacing of the plot to be 0.3 on the Y axis
set(gca, 'YTick',0:0.3:0.9);
set(gca, 'YTickLabel', [ 0:0.3:0.9 ] );

% set the minor ticks on the axis
set(gca, 'XMinorTick', 'on');
set(gca, 'YMinorTick', 'on');

 % compute/plot the spectral locus
locus = XYZ2XyYMany(cie.cmf2deg');
plot(locus(1,[1:81,1]),locus(2,[1:81,1]), 'k-', 'LineWidth', line_weight);  

% draw the wavelength numbers
l = [380 450 500 525 550 575 600 625 650 780];
for j=1:size(l,2),
     p = find(cie.lambda == l(j));
     moveUp = 0.02;
     if l(j) == 450,
         moveUp = 0.03;
     end
     if l(j) == 780,
         moveUp = 0.0;
     end
     text(locus(1,p)+.02,locus(2,p)+moveUp,num2str(l(j)));
     plot(locus(1,p),locus(2,p),'ko','MarkerFaceColor','k');
end

hold on
% draw the major CIE illuminants
% D65
text(0.31271-0.03,0.32902+0.03,'D65');
plot(0.31271,0.32902,'ko','MarkerFaceColor','k'); 

% D50 
text(0.34567-0.03,0.35850+0.03,'D50');
plot(0.34567,0.35850,'ko','MarkerFaceColor','k');

% A
text(0.44757,0.40745+0.03,'A');
plot(0.44757,0.40745,'ko','MarkerFaceColor','k');

% Calculated values for swatches
l1 = plot(xyY161RealCalc(1),xyY161RealCalc(2), 'ko','MarkerFaceColor','r');
l2 = plot(xyY161ImagedCalc(1),xyY161ImagedCalc(2), 'g','MarkerFaceColor','y');
l3 = plot(xyY161MatchingCalc(1),xyY161MatchingCalc(2), 'c','MarkerFaceColor','m');
l4 = plot(xyY162RealCalc(1),xyY162RealCalc(2), 'ko','MarkerFaceColor','c');
l5 = plot(xyY162ImagedCalc(1),xyY162ImagedCalc(2), 'g','MarkerFaceColor','b');
l6 = plot(xyY162MatchingCalc(1),xyY162MatchingCalc(2), 'c','MarkerFaceColor','g');

legend([l1 l2 l3 l4 l5 l6],{'16.1 real', '16.1 imaged', '16.1 matching',...
    '16.2 real', '16.2 imaged', '16.2 matching'})

% Measured values for swatches
plot(xyY161Real(1),xyY161Real(2), '*','MarkerFaceColor','r');
plot(xyY161Imaged(1),xyY161Imaged(2), '*','MarkerFaceColor','y');
plot(xyY161Matching(1),xyY161Matching(2), '*','MarkerFaceColor','m');
plot(xyY162Real(1),xyY162Real(2), '*','MarkerFaceColor','c');
plot(xyY162Imaged(1),xyY162Imaged(2), '*','MarkerFaceColor','b');
plot(xyY162Matching(1),xyY162Matching(2), '*','MarkerFaceColor','g');