% Given a display model matrix and lookup tables, convert a set of 
% XYZ coords using black reference XYZ into scalar RGBs

%Prerequisites - valid load_ramps_data_1516 script on path
function [ result ] = derriveRGBs( XYZs, dispModel )
    run load_ramps_data_1516;
    cie = loadCIEData();
    D50_XYZ = ref2XYZ(cie.illE, cie.cmf2deg, cie.illD50); 	
    D65_XYZ = ref2XYZ(cie.illE, cie.cmf2deg, cie.illD50);

    adapt_XYZs = catBradford(XYZs',D50_XYZ, D65_XYZ);

    % Subtract XYZ black from each adapted value
    adapt_sz = size(adapt_XYZs);
    adapt_XYZs = adapt_XYZs' - repmat(black_XYZ,adapt_sz(2),1);

    %Multiply by matrix to obtain radiometric scalars
    scalars = adapt_XYZs * dispModel.M_disp';

    % Normalize scalars by 100
    scalars = scalars/100;

    % Clip any out of range values
    scalars(scalars<0) = 0;
    scalars(scalars>1) = 1;

    %Multiply scalars by 1023 and round to nearest integer
    scalars = round(scalars * 1023) + 1;

    % Convert to 8 bit unsigned integers
    R_LUT_RESULT = uint8(dispModel.RLUT_disp(scalars(:,1)))';
    G_LUT_RESULT = uint8(dispModel.GLUT_disp(scalars(:,2)))';
    B_LUT_RESULT = uint8(dispModel.BLUT_disp(scalars(:,3)))';

    result = [R_LUT_RESULT G_LUT_RESULT B_LUT_RESULT];
end

