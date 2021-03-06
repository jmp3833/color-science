cla
cie = loadCIEData();
plot(cie.lambda, cie.cmf10deg, '--', cie.lambda, cie.cmf2deg);
title('CIE Standard Observer CMFs')
legend('xbar 2deg', 'ybar 2deg', 'zbar 2deg', 'xbar 10deg', 'ybar 10deg', 'zbar 10deg')
xlabel('wavelength(nm)');
ylabel('tristimulus values');