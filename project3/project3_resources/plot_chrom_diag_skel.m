% plot_chrom_diag_skel.m
% plot the skeleton of the chromaticity diagram, with spectral locus and
% major illuminants
% requires a new blank figure and the loadCIEdata and XYZ2xyY functions
% 2/24/16 jaf

% load the CIE observer and illuminant data
cie = loadCIEdata;

% create a new figure with hold on and line_width = 1.5
figure;
hold on;
line_weight = 1.5;

set(gca, 'FontSize', 14);
set(gca, 'LineWidth', line_weight);
axis('equal'); % make plot scales equal
axis([0,0.9,0,0.9]); % set the axis ranges
xlabel('x');
ylabel('y');

% set the min and max for each axis of the plot
axis([0 0.9 0 0.9],'xy');

% force the tick spacing of the plot to be 0.3 on the X axis
set(gca, 'XTick', 0:0.3:0.9);
set(gca, 'XTickLabel', [ 0:0.3:0.9 ] );

% force the tick spacing of the plot to be 0.3 on the Y axis
set(gca, 'YTick',0:0.3:0.9);
set(gca, 'YTickLabel', [ 0:0.3:0.9 ] );

% set the minor ticks on the axis
set(gca, 'XMinorTick', 'on');
set(gca, 'YMinorTick', 'on');

 % compute/plot the spectral locus
locus = XYZ2xyY(cie.cmf2deg');
plot(locus(1,[1:81,1]),locus(2,[1:81,1]), 'k-', 'LineWidth', line_weight);

% draw the wavelength numbers
l = [380 450 500 525 550 575 600 625 650 780];
for j=1:size(l,2),
     p = find(cie.lambda == l(j));
     moveUp = 0.02;
     if l(j) == 450,
         moveUp = 0.03;
     end
     if l(j) == 780,
         moveUp = 0.0;
     end
     text(locus(1,p)+.02,locus(2,p)+moveUp,num2str(l(j)));
     plot(locus(1,p),locus(2,p),'ko','MarkerFaceColor','k');
end

% draw the major CIE illuminants
% D65
text(0.31271-0.03,0.32902+0.03,'D65');
plot(0.31271,0.32902,'ko','MarkerFaceColor','k'); 

% D50 
text(0.34567-0.03,0.35850+0.03,'D50');
plot(0.34567,0.35850,'ko','MarkerFaceColor','k');

% A
text(0.44757,0.40745+0.03,'A');
plot(0.44757,0.40745,'ko','MarkerFaceColor','k');