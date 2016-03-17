%Calculate delta values between two sets of Lab values
%This function operates on a 3 x n column matrix
function DEab = deltaEab (Lab1, Lab2)

  sz = size(Lab1);
  numCols = sz(2);
  
  for col = 1:(numCols) 
    l1 = Lab1(:,col);
    l2 = Lab2(:,col);
    DEab(col) = sqrt((l2(1) - l1(1))^2 + (l2(2) - l1(2))^2 + (l2(3) - l1(3))^2)
  end
  
end