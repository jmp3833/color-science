%Calculate delta values between two sets of Lab values
%This function operates on a 3 x n column matrix
function DEab = deltaEab (Lab1, Lab2)
    DEab = sqrt((Lab2(1,:) - Lab1(1,:)).^2 + (Lab2(2,:) - Lab1(2,:)).^2 ...
    + (Lab2(3,:) - Lab1(3,:)).^2);
end