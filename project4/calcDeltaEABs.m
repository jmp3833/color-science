%Import MetaChecker and ColorChecker values to 81x25 matrices
colorChecker = importdata('ColorChecker_380-780-5nm.txt');
metaChecker = importdata('MetaChecker_380-780-5nm.txt');

%Import CIE data into struct
cie = loadCIEData();

%Calculate XYZ values of samples under A and D65 light sources with 2deg
%std observer
colorCheckerD65XYZs = ref2XYZ(colorChecker, cie.cmf2deg, cie.illD65);
colorCheckerAXYZs = ref2XYZ(colorChecker, cie.cmf2deg, cie.illA);
metaCheckerD65XYZs = ref2XYZ(metaChecker, cie.cmf2deg, cie.illD65);
metaCheckerAXYZs = ref2XYZ(metaChecker, cie.cmf2deg, cie.illA);

%Supply XYZ values for A and D65 light sources using 2deg std ovserver
XYZn_D65 = ref2XYZ(cie.illE,cie.cmf2deg,cie.illD65);
XYZn_A = ref2XYZ(cie.illE,cie.cmf2deg,cie.illA);

%Calculate LAB values for color and meta checkers under D65 and A light
colorCheckerD65LABs = XYZ2Lab(colorCheckerD65XYZs, XYZn_D65);
colorCheckerALABs = XYZ2Lab(colorCheckerAXYZs, XYZn_A);
metaCheckerD65LABs = XYZ2Lab(metaCheckerD65XYZs, XYZn_D65);
metaCheckerALABs = XYZ2Lab(metaCheckerAXYZs, XYZn_A);

%Calculate DeltaEAB values for samples under A and D65
deltaALab = deltaEab(colorCheckerALABs, metaCheckerALABs);
deltaD65Lab = deltaEab(colorCheckerD65LABs, metaCheckerD65LABs);

%Generate result string to print
res = [ 1:1:24; deltaD65Lab(2:25); deltaALab(2:25);];

%Print Column Matrices in formatted table
fprintf('Patch #\tDELab D65\tDEab illA\n')
fprintf(1, [repmat('%d\t   %2.4d\t   %2.3f\n', 1, 25) '\n'], res);

%Calc XYZ values of real, imaged, and matching patches
patchXYZs = calcColorMunkiXYZs();
XYZn_D50 = ref2XYZ(cie.illE,cie.cmf2deg,cie.illD50);

patchLABs = XYZ2Lab(patchXYZs, XYZn_D50);

%Compare LAB values of real, imaged, and matching patches
real161imaged = deltaEab(patchLABs(:,1), patchLABs(:,2));
real161matching = deltaEab(patchLABs(:,1), patchLABs(:,3));
real162imaged = deltaEab(patchLABs(:,4), patchLABs(:,5));
real162matching = deltaEab(patchLABs(:,4), patchLABs(:,6));