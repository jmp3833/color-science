% quickstart_data.m
% 2/24/16 jaf


%%
% simple numeric data types

% doubles (default numeric type)
clear all;
a = 3
b = 3.14
c = 3.14e3
d = realmax('double')
e = realmin('double')

% singles 
clear all;
a = 3.14
b = single(3.14)
c = realmax('single')
d = realmin('single')

% special values
clear all
a = 1/0 % = infinity
b = -inf % = negative infinity
c = inf - inf  % nan (not a number)
d = 0/0 % nan
e = [a,b,c,d,3,3.14,pi]
infs = isinf(e)
nans = isnan(e)
fins = isfinite(e)

% ints
clear all;
a = uint8(3)
b = uint8(3.14)
c = uint8(258)
d = intmax('uint8')
e = intmax('uint16')
f = intmax('int8')
g = intmin('int8')

%%
% vectors and arrays

% 1d and 2d arrays
clear all;
a = [1,2,3,4,5]
b = [1;2;3;4;5]
c = transpose(a)
d = a'
e = [1:24]
f = reshape(e,[4,6])
g = f'
h = permute(f,[2,1])
i = reshape(e,[6,4])'

% 3d arrays
a = rand(2,2,3)
b = reshape([1:12],[2,2,3])
c = permute(b,[3,2,1])
size(b)
size(c)

d = a(:,:,1)
e = repmat(d,[2,2])
f = repmat(d,[1,1,3])
g = cat(1,d,d,d)
h = cat(2,d,d,d)
i = cat(3,d,d,d)

% essential color science method using reshape for matrix math on images
% 1) reshape image into pixel vector
% 2) process through 3x3
% 3) reshape into image
img_in = rand(2,2,3);
figure;
imagesc(img_in);
[r,c,p] = size(img_in);
pix_vec_in = reshape(img_in,[r*c,p])';
matrix = eye(3)*0.5;
pix_vec_out = matrix * pix_vec_in;
img_out = reshape(pix_vec_out', [r,c,p]);
figure;
imagesc(img_out);

%%
% characters and strings

% chars
clear all
a = 'A'
b = char(65)
c = double('A')

% char strings
clear all
a = 'my string'
m = a(1)
r = a(6)
pi_num = str2num('3.14')
pi_str = num2str(3.14)

% char arrays
clear all
A = char(zeros(2,5))
A(1,1) = 'R'
A(1,2) = 'I'
A(1,3) = 'T'
A(2,:) = ' WTF '
whos A
B = deblank(A(2,:))
whos B
C = strtrim(A(2,:))
whos C

% strings of different lengths in char arrays
clear all
A = 'poop'
whos A
A(2,:) = 'ha ha he said poop'
A(2,1:18) = 'ha ha he said poop'
whos A

%%
% cell arrays

% cell arrays
C = cell(2,4)
C{1,1} = 'poop'
C{2,1} = 'ha ha he said poop'
C{1,2} = 'pee'
C{2,2} = 'he said pee too'
C{1,3} =  'pie'
C{2,3} = 3.14
C{1,4} = rand(3)

celldisp(C)

poop_cell = C(1,1)
poop_string = C{1,1}
poop_string = poop_cell{:}
pi_cell = C(2,3)
pi_num = C{2,3}

%%
% structures

% simple structure
clear all
id.name = 'Bob Loblaw'
id.profession = 'attorney'
id.age = 42

% arrays of structures
clear all
ids(1).name = 'Bob Loblaw'
ids(1).profession = 'attorney'
ids(1).age = 42

ids(2).name = 'Bob Dobbs'
ids(2).profession = 'troublemaker'
ids(2).GPS_coords = [43.0844 77.6749]

% structures of arrays
clear all
my_fav_colors.yellow = [1 0 1]
my_fav_colors.greens = [0 1 0; 0 0.5 0; 0 0.25 0]


%%
% manipulating data

% 1d interpolation
clear all
orig_xs = linspace(0,2*pi,10);
orig_ys = sin(orig_xs);
finer_xs = linspace(0,2*pi,20);
wider_xs = linspace(0,3*pi,30);
interp_ys_lin = interp1(orig_xs, orig_ys, finer_xs, 'linear');
interp_ys_cub = interp1(orig_xs, orig_ys, finer_xs, 'pchip');

figure;
hold on;
plot(orig_xs, orig_ys,'ko')
plot(finer_xs, interp_ys_lin, 'm-');
plot(finer_xs, interp_ys_cub, 'b-');
legend('original','linear','cubic');


% 1d interpolation/extrapolation
extrap_ys_lin = interp1(orig_xs, orig_ys, wider_xs, 'linear', 'extrap');
extrap_ys_cub = interp1(orig_xs, orig_ys, wider_xs, 'pchip', 'extrap');

figure;
hold on;
plot(orig_xs, orig_ys,'ko')
plot(wider_xs, extrap_ys_lin, 'm-');
plot(wider_xs, extrap_ys_cub, 'b-');
legend('original','linear','cubic');


% 2d interpolation (from Matlab documentation)
clear all
[X,Y] = meshgrid(-3:3);
V = peaks(X,Y);

figure;
surf(X,Y,V);
title('Original Sampling');


[Xq,Yq] = meshgrid(-3:0.25:3);
Vq = interp2(X,Y,V,Xq,Yq,'cubic');

figure
surf(Xq,Yq,Vq);
title('Cubic Interpolation Over Finer Grid');

%%
% formatted output
clear all
x = 1:10;
y = [x; exp(x)];
y'
fprintf('%d:\t %10.4f\n',y);

% formatted output to a file
fid = fopen('formatted_output.txt', 'w');
fprintf(fid, '%d:\t %10.4f\n',y);
fprintf(fid, 'the quick brown fox, %d, %d, %d\n', x(1:3));
fclose(fid);

% generating formatted strings
clear all
for i = 1:3
    str1 = sprintf('OutputFileName%d.txt', i)
end

for i = 1:3
    str2 = strcat('OutputFileName',num2str(i),'.txt')
end
