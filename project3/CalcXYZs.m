
%Generate CIE struct 
cie = loadCIEData();

%Import spectral data of all color patches into a matrix
CC_spectra = importdata('ColorChecker_380_780_5nm.txt');

%Calculate the size of columns in the matrix to iterate over
CC_delimited_spectra = CC_spectra(:,2:25);
sz = size(CC_delimited_spectra);
numCols = sz(2);

%For every matrix column, calculate it's XYZ values against 2 deg standard
%observer in D65 light
for col=1:(numCols)
  xyzs(:,col) = ref2XYZ(CC_delimited_spectra(:,col),cie.cmf2deg,cie.illD65);
end

%Show xyz values calculated form color chart
disp(xyzs)

XyYResults = XYZ2XyYMany(xyzs)