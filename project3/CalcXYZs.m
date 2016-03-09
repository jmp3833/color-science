cie = loadCIEData();
CC_spectra = importdata('ColorChecker_380_780_5nm.txt');

CC_spectra = CC_spectra(:,2:25);
C = ref2XYZ(CC_spectra,cie.cmf2deg,cie.illD65);

xyzs = cellfun(@sum,C);