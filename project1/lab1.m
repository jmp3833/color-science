%Implementation of laboratory exercise 1
%02/04/2016
%Justin Peterson

%Beginning on a clean slate. Close workspace and command windows
clear all;
close all;
clc;

%Read in image of color swatch
swatchAndChecker = imread('swatch.jpg');

%Dimensions of crop rectangles specific to Justin Peterson's image
%Remove second argument of imcrop functions to pick your own crops!
justinCheckerLocation = [252.5 419.5 1755 1221];
justinSwatchLocation = [2094.5 1157.5 375 483];

%Crop of individual swatch image
swatch = imcrop(swatchAndChecker, justinSwatchLocation);

%Crop of color checker
checker = imcrop(swatchAndChecker, justinCheckerLocation);

%Resize image of swatch to 1125x800
checker = imresize(checker, [800, 1125]);

%Resize image of swatch to 225x300
swatch = imresize(swatch, [300, 225]);

%Write swatch and color checker to individual images.
imwrite(checker, 'chart.jpg');
imwrite(swatch, 'patches.jpg');

sprintf('All done!');