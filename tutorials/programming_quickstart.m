% programming quickstart
% 1/31/16 jaf

%%
% scripts
% To create a new script Home->New->Script. Copy/paste comments/commands
% below to new script. Save as cleanup.m. To execute type "cleanup" in
% command window

% cleanup.m - remove all session content
% 1/31/16, created, jaf
clear all;
close all;
clc;


%%
% functions
% To create a new function Home->New->Function. Rename function to "immax",
% name input/ output parameters to "img","max_val", enter code between
% "function" and "end" statements. Save as immax.m. To execute define
% "img_array", type "result = immax(img_array)"

function [max_val] = immax(img)
%  immax - compute the maximum of an image (2d x n channel array)
% img - image array
% max_val - max val in image
max_val = max(max(img));

end

%%
% note: immax returns the max vals in each channel, may not be the same
% pixel.
img = imread('sophie_srgb.jpg');
immax(img)


%%
% relational operators 
% Results are of type "logical".
a = 5;
b = 3;
c = [1 2 3 4 5];

a == b
a > b
a <= b
c <= b
c ~= b


%%
% flow control

% if-elseif-else-end
x = 1;
y = 3;

if x > y
  fprintf('x is greater than y\n');
else if x == y
  fprintf('x equals y\n');
    else
        fprintf('x is less than y\n');
    end
end

% switch-case-otherwise-end
num = 3;
switch num
    case 1
        fprintf('the number is 1\n');
    case 3
        fprintf('the number is 3\n');
    case 5
        fprintf('the number is 5\n');
    otherwise
            fprintf('I don''t know what the number is\n');
end

% switch-case using strings and multiple selectors
% Copy/paste into blank script. Save as countLimbs.m
% Try countLimbs('dog'); countLimbs('frog');
function countLimbs(animalName)
 
% initialize output
legs = 0; arms = 0; wings = 0;
 
% switch on animal name
switch lower(animalName)
    case {'dog','cat','bear','goat'}
        legs =4;
    case {'human','bird'}
        legs = 2;
        if strcmp(animalName,'human')
            arms = 2;
        else
            wings = 2;
        end
    case 'fish'
    case 'spider'
        legs = 8;
    case 'millipede'
        legs = 1000;
    otherwise
        warning(sprintf('Unknown Animal: %s', animalName));
        return;
end

fprintf('A %s has % d legs, %d arms, and %d wings\n', animalName,legs,arms,wings);

end

%%
% looping

% for-end
m = ones(5);
for rows = 1:3
    for cols = 1:2
        m(rows,cols) = 0;
    end
end

% or in /real/ Matlab 
m = ones(5);
m(1:3,1:2) = 0;


% while-end
x = 5;
while x >= 0
    fprintf('x = %d\n',x);
    x = x-1;
end
    
% while-end with vector input
y = [2 3 4 8 13]
while ~isempty(y)
    disp(y);
    y = y(2:end);
    if y(1) == 8
        break;
    end
end

%%
% find 
% Returns indices to non-zero elements or elements that satisfy
% a conditional expression.

% 1d arrays
x = [1 0 -2 0 5 0]
find(x)
find(x==0)
find(x<0)

% 2d arrays are stored with "row major" indices.
x = [1 0 -2; 0 5 0]
find(x)

% Return row and col indices and value.
x = [1 0 -2; 0 5 0]
[row,col,val] = find(x)


% Using find to clip values to a range
x = [-0.1 0.5 1.1 0.6];
x(find(x<0.0)) = 0.0;
x(find(x>1.0)) = 1.0;


%%
% conditional equations

% example 1: absolute value using find
x = [-1 0 3 -4]
y = x
neg_idx = find(x<0)
y(neg_idx) = -x(neg_idx)

% example 2: absolute value using logical indexing
x = [-1 0 3 -4]
neg_idx = (x<0)
y = (~neg_idx).*x + (neg_idx).*-x

% example 3: absolute value using relational operators
x = [-1 0 3 -4]
y = (x>=0).*x + (x<0).*-x


%%
% anonymous functions 
% Like macros, for defining simple functions inside
% other scripts or functions.
myabs = @(x) (x>=0).*x + (x<0).*-x;

