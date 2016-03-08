cla
cie = loadCIEData();
plot(cie.lambda,blackbody([2856,5003,6504],cie.lambda), cie.lambda, ...
    (cie.illA ./100), '--', cie.lambda, (cie.illD50 ./ 100), '--',...
    cie.lambda,(cie.illD65 ./ 100), '--')
title('blackbody and standard illuminant spectra')
axis([350 800 0 2.5])
xlabel('wavelength(nm)');
ylabel('relative power');
legend('blackbody 2856k', 'blackbody 5003k', 'blackbody 6504k',...
    'Illuminant A', 'Illuminant D50', 'Illuminant D65')