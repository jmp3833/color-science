%Load CIE Information from a series of provided text files.
%Loads into a struct titled cie with 10 defined properties

%Separate functions are defined to load either the first column
%of a textfile (importLambda), the last three columns (importCMF),
%the second column(importCData), or the final 12 columns (importIllF)

%Authors: Team 14 (Jusitn & Jenee) 

function[cie] = loadCIEData()

cie.lambda = importLambda('CIE_2Deg_380-780-5nm.txt')';

cie.cmf2deg = importCMF('CIE_2Deg_380-780-5nm.txt');
cie.cmf10deg = importCMF('CIE_10Deg_380-780-5nm.txt');
cie.eigD = importCMF('CIE_eigD_380-780-5nm.txt');

cie.illA = importCData('CIE_IllA_380-780-5nm.txt');
cie.illC = importCData('CIE_IllC_380-780-5nm.txt');
cie.illD50 = importCData('CIE_IllD50_380-780-5nm.txt');
cie.illD65 = importCData('CIE_IllD65_380-780-5nm.txt');

cie.illF = importIllF('CIE_IllF_1-12_380-780-5nm.txt');

cie.illE = linspace(1,1,81)';