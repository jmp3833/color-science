%% Project 7: Color Reproduction. Team 14 (Jenee L & Justin P.)

%%Multiply munki XYZs by display model
colorMunkiData = importdata('munki_CC_XYZs_Labs.txt');
munkiXYZs = colorMunkiData(:,2:4);
munkiLABs = colorMunkiData(:,5:7);

dispModel = importdata('display_model.mat');
RGBCoords = derriveRGBs(munkiXYZs, dispModel);

%Scale RGB coordinates to a 0-100 range
RGBCoords = RGBCoords * (100/255);

