%% Calculation of Lab Values for ColorChecker Charts
%% Team 14 - Justin Peterson and Jenee Langlois

%Script to calculate XYZ and LAB values for color checker chart under 2deg
%standard observer and D65 light source. Format into a text table fr pretty
%printing with color chart names

%Fetch color values for each patch (omitting name field)
CC_spectra = importdata('ColorChecker_380_780_5nm.txt');
CC_delimited_spectra = CC_spectra(:,2:25);

%Load CIE struct
cie = loadCIEData();

% Calculate XYZ values for D65 light
XYZn_D65 = ref2XYZ(cie.illE,cie.cmf2deg,cie.illD65);

% Calculate all xyz values for colorchecker chart w/ 2 deg observer and D65
% light source
xyzs = ref2XYZ(CC_delimited_spectra, cie.cmf2deg, cie.illD65);
result = XYZ2Lab(xyzs, XYZn_D65);

% Read names of patches to pump into table
names = textread('ColorChecker_names.txt','%s','delimiter','|');

%Pretty print table of XYZ and Lab values for color patches
fprintf('ColorChecker XYZ and Lab values (D65 Illuminant and 2deg. observer)');
fprintf('\nPatch #\tX\tY\tZ\tL\ta\tb\t Patch Name\n');

sz = size(xyzs);
numCols = sz(2);
  
for col = 1:(numCols)
  xyz = xyzs(:,col);
  
  x = xyz(1);
  y = xyz(2);
  z = xyz(3);
  
  lab = result(:,col);
  l = lab(1);
  a = lab(2);
  b = lab(3);
  
  strn = names{col};
  
  fprintf('%i\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%s \n',col,x,y,z,l,a,b, strn);
  
end

%Print table with reduced values to trigger alternate Lab calculation
smallCheckerReadings = CC_delimited_spectra.*(.02);

% Calculate all xyz values for colorchecker chart w/ 2 deg observer and D65
% light source

%% CC_Delimeted spectra XYZs

xyzs = ref2XYZ(smallCheckerReadings, cie.cmf2deg, cie.illD65);
fprintf('CC_XYZs = \n');
disp(xyzs);
result = XYZ2Lab(xyzs, XYZn_D65);

fprintf('ColorChecker(Dark) XYZ and Lab values (D65 Illuminant and 2deg. observer)');
fprintf('\nPatch #\tX\tY\tZ\tL\ta\tb\t Patch Name\n');

sz = size(xyzs);
numCols = sz(2);
  
for col = 1:(numCols)
  xyz = xyzs(:,col);
  
  x = xyz(1);
  y = xyz(2);
  z = xyz(3);
  
  lab = result(:,col);
  l = lab(1);
  a = lab(2);
  b = lab(3);
  
  strn = names{col};
  
  fprintf('%i\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%.3f\t%s \n',col,x,y,z,l,a,b, strn);
  
end

%display functions used for reporting
dbtype('ref2XYZ.m')
dbtype('XYZ2LAB.m')
dbtype('deltaEab.m');
