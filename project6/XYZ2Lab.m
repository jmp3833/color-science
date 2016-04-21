%% XYZ2Lab Function
% Takes a 3 X n array of tristimulus values as well as the 3 X 1 
% tristimulus values of a reference illuminant
% and returns a 3 X n array of
% CIElab values based on these tristimulus values.
function Lab = XYZ2Lab(XYZ, XYZn)

      % Calculate function result values that will be required to calculate Lab
      funcXXn = calcLabFuncResult(XYZ(1, :) / XYZn(1));
      funcYYn = calcLabFuncResult(XYZ(2, :) / XYZn(2));
      funcZZn = calcLabFuncResult(XYZ(3, :) / XYZn(3));

      % Calculate individual Lab values
      L = 116 * funcYYn - 16;
      a = 500 * (funcXXn - funcYYn);
      b = 200 * (funcYYn - funcZZn);
      
      Lab = [L;a;b];
      
      
end

% Calculates the inner value of f(x) in the CIELab algorithm
% The result of x will be calculated differently based on the value of X

%if x > .008856, calc x^(1/3)
%otherwise calc 7.787x + 16/116
function fResult = calcLabFuncResult(x)
  x(x > .008856) = x(x > .008856).^(1/3);
  x(x <= .008856) = x(x <= .008856) * 7.787 + (16/116);
  
  fResult = x;
end
