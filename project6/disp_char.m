%% Lab 6 - Display Characterization: Team 14 (Jenee Janglois & Justin Peterson)

%% Import Ramps Data

%Invoke professor provided script
run load_ramps_data_1516;

% Fetch largest XYZs for R G and B channels
MAX_XYZS = [ramp_R_XYZs(11,:);ramp_G_XYZs(11,:);ramp_B_XYZs(11,:)];

m_fwd = derive_fwd_matrix(MAX_XYZS, black_XYZ, white_XYZ);