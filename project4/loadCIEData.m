function [cie] = loadCIEdata
% loadCIEdata.m
% load CIE data into a structure
% 3/16/16 jaf

%set the wavelength range
cie.lambda = [380:5:780];

%load the CIE color matching function data
cie.cmf2deg = load('CIE_2Deg_380-780-5nm.txt');
cie.cmf10deg = load('CIE_10Deg_380-780-5nm.txt');

% load the CIE illuminant data
cie.illA = load('CIE_IllA_380-780-5nm.txt');
cie.illC = load('CIE_IllC_380-780-5nm.txt');
cie.illD50 = load('CIE_IllD50_380-780-5nm.txt');
cie.illD65 = load('CIE_IllD65_380-780-5nm.txt');
cie.illE = ones(length(cie.lambda),1);
cie.illF = load('CIE_IllF_1-12_380-780-5nm.txt');
cie.eigD = load('CIE_eigD_380-780-5nm.txt');

% interpolate the data over the range and spacing of cie.lambda
interpMethod = 'linear';
cie.cmf2deg = interp1(cie.cmf2deg(:,1),cie.cmf2deg(:,2:end),cie.lambda(:),interpMethod);
cie.cmf10deg = interp1(cie.cmf10deg(:,1),cie.cmf10deg(:,2:end),cie.lambda(:),interpMethod);
cie.illA = interp1(cie.illA(:,1),cie.illA(:,2:end),cie.lambda(:),interpMethod);
cie.illC = interp1(cie.illC(:,1),cie.illC(:,2:end),cie.lambda(:),interpMethod);
cie.illD50 = interp1(cie.illD50(:,1),cie.illD50(:,2:end),cie.lambda(:),interpMethod);
cie.illD65 = interp1(cie.illD65(:,1),cie.illD65(:,2:end),cie.lambda(:),interpMethod);
cie.illF = interp1(cie.illF(:,1),cie.illF(:,2:end),cie.lambda(:),interpMethod);
cie.eigD = interp1(cie.eigD(:,1),cie.eigD(:,2:end),cie.lambda(:),interpMethod);