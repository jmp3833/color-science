%Produces a three line plot with appropriate legend
%for colormunki readings. Accepts array of 3 filenames
%as a function call.
function[] = plotreading(filenames)

%Generic array of y axis values for graph
yAxisValues = linspace(380,730,36);

%For every file in list of files, read data and add to graph
for fileInd = 1:numel(filenames)
    
    %Read in file
    readings = fopen(char(filenames(fileInd)), 'r');

    %Reading off headers of colormunki file, throwing away lines
    for i = 0:16
        fgets(readings);
    end

    %Here's the line we actually want to read!
    lines = fscanf(readings,'%f');
    
    %add line to graph plot
    plot(yAxisValues,lines)
    axis([380,730,0,100])
    hold on
end

legend('real', 'imaged', 'matching')


