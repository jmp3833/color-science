% graphics quickstart
% 1/30/16 jaf

%%
% Create some data for plotting.
x = linspace(0,2*pi,100);
ysin = sin(x);
ycos = cos(x);

%%
% Plot the data. Note that the plot command opens a new figure. Note that 
% successive plot commands replace the data in the figure.
plot(x,ysin);
plot(x,ycos);

% "close" will close the current figure
% close


%%
% If you want one graph with two or more curves use "hold on" between 
% the plot commands
plot(x,ysin);
hold on
plot(x,ycos);

% or

plot(x,ysin,x,ycos);

% "close all" will close all figures
% close all


%%
% If you want two graphs, "figure;" will create a new figure so the new
% data doesn't replace the old. Using the syntax handle = plot(...)
% assigns the figure a handle that can be used for reference (for example
% closing the figure with "figure(handle)".
figure1 = plot(x,ysin);
figure;
figure2 = plot(x,ycos);

% close(figure1);
% close(figure2);


%%
% All the properties of the graph can be changed. Some properties can be
% specified in the "plot" command. Some can be set with dedicated commands 
% like "axis" and "title", many others can be queried and changed by
% editing the structure provided by the "gca" command. See "plot", "gca",
% "gcf" for more info.
plot(x,ysin,'b-');
hold on;
plot(x,ycos,'r--','LineWidth',2);
plot(x,ycos.^2,'ko');
axis([0,2*pi,-1.2,1.2]);
ax = gca;
ax.FontSize = 16;
ax.XTick = round(linspace(0,2*pi,5),2);
title('plotting demo');
xlabel('x values')
ylabel('calculated values');
legend('sine','cosine','cosine^2','Location','SouthEast');

%%
% Matlab also has many tools for creating and manipluating 3D+ graphs.
x=linspace(-3,3);
y=x;
[X,Y]=meshgrid(x,y);
Z=exp(-(X.^2+Y.^2));
surf(X,Y,Z);
shading faceted
axis([-3 3 -3 3 0 1]);

%%
% change the shading
shading interp

%%
% change the colormap
colormap hot

%%
% change the view
view(45,45);

%%
% change the view to overhead and set the axes equal and off
% useful for creating "image" views to complement 3D graphs
view(0,90);
axis('image');
axis('off');



%%
% There are /many/ different kinds of graphics tools in Matlab. For more
% info type
demo matlab


