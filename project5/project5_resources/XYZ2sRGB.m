function sRGB = xyz2srgb(inXYZ)
% render XYZ tristimulus values as sRGBs
% sRGBs are gamma corrected but still scaled 0-1
% multiply by 255 to make standard RGB digital counts
% adapted from original by LAT, 3/14/15 jaf

    XYZ2sRGB=[3.2406,-1.5372,-0.4986;-0.9689,1.8758,0.0415;0.0557,-0.2040,1.0570]/100;
    sRGB = min(max(XYZ2sRGB*inXYZ,0),1);
    sRGB = (sRGB.*12.92).*(sRGB<=0.0031308) + ((1.055.*sRGB).^(1/2.4)-0.055).*(sRGB>0.0031308);
    sRGB = min(max(sRGB,0),1);    