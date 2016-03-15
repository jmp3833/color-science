% Takes a 3 X n array of tristimulus values as well as the 3 X 1 
% tristimulus values of a reference illuminant
% and returns a 3 X n array of
% CIElab values based on these tristimulus values.
function Lab = XYZ2Lab(XYZ, XYZn)

  sz = size(XYZ);
  numCols = sz(2);
  
  for col = 1:(numCols)
      
      XYZind = XYZ(:,col);

      % Calculate function result values that will be required to calculate Lab
      funcXXn = calcLabFuncResult(XYZind(1) / XYZn(1));
      funcYYn = calcLabFuncResult(XYZind(2) / XYZn(2));
      funcZZn = calcLabFuncResult(XYZind(3) / XYZn(3));

      % Calculate individual Lab values
      L = 116 * funcYYn - 16;
      a = 500 * (funcXXn - funcYYn);
      b = 200 * (funcYYn - funcZZn);
      
      labInd = [L, a, b];

      % Append lab values to 3 x 1 array
      Lab(:,col) = labInd;
  end
end

% Calculates the inner value of f(x) in the CIELab algorithm
% The result of x will be calculated differently based on the value of X

%if x > .008856, calc x^(1/3)
%otherwise calc 7.787x + 16/116
function fResult = calcLabFuncResult(x)
  if x > .008856
    fResult = x ^ (1/3);   
  else
    fResult = 7.787 * x + (16/116);
  end
end
