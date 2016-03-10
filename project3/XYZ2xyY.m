function xyY= XYZ2xyY(X,Y,Z)

x = X/(X+Y+Z);

y = Y/(X+Y+Z);

xyY = [x,y,Y];

end 
