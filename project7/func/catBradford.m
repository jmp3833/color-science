function [XYZ2] = catBradford(XYZ1, XYZn1, XYZn2);
% use the Bradford form of the CIECAT02 chromatic adaptation matrix to convert XYZs calculated 
% using illuminant (XYZn1) to their equivalents w.r.t. illuminant (XYZn2)
% tweaked from original cat02.m, 3/14/15 jaf

MCAT = [0.8951, 0.2664, -0.1614; -0.7502, 1.7035, 0.0367; 0.0389, -0.0685, 1.0296];

RGB1 = MCAT*XYZn1;
RGB2 = MCAT*XYZn2;

XYZ2 = inv(MCAT)*diag(RGB2./RGB1)*MCAT*XYZ1;