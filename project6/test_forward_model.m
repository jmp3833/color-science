% test_forward_model.m
% Test the by display model by using it to calculate XYZ
% values from RGB digital counts. Evaluate the accuracy of the model by 
% computing deltaEab differences between the measured and calculated XYZ
% values
% 11/3/13 jaf

% read in the Argyll/Munki RGB cube sampling data
cube = importdata('cube.ti3',' ',27);

% extract the RGB digital counts and the measured XYZs
cube_DCs = int16((cube.data(:,2:4)./100).*255);
measured_XYZs = cube.data(:,5:7);

% push the DCs through the forward LUTs to predict radiometric scalars
for i=1:size(cube.data,1)
    cube_RSs(1,i) = RLUT_fwd(cube_DCs(i,1)+1);
    cube_RSs(2,i) = GLUT_fwd(cube_DCs(i,2)+1);
    cube_RSs(3,i) = BLUT_fwd(cube_DCs(i,3)+1);
end

% add the homogeneous coordinate required to apply the forward matrix
cube_RSs_h = [cube_RSs; ones(1,size(cube_RSs,2))];

% apply the forward matrix to the RSs to calculate model-predicted XYZs 
modeled_XYZs = M_fwd * cube_RSs_h * 100;

% load the CIE data and calculate XYZs for D50
cie = loadCIEdata;
XYZ_illD50 = ref2XYZ(cie.illE,cie.cmf2deg,cie.illD50);

% convert the measured and modeled XYZs to Labs
measured_Labs = XYZ2Lab(measured_XYZs', XYZ_illD50);
modeled_Labs = XYZ2Lab(modeled_XYZs, XYZ_illD50);

% calculate deltaE differences between the measured and modeled Labs
% and report the statistics
deltaEs = deltaEab(measured_Labs,modeled_Labs);
max_deltaE = max(deltaEs)
min_deltaE = min(deltaEs)
mean_deltaE = mean(deltaEs)