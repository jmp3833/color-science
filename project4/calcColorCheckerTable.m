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


