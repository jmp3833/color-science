function xyYs= XYZ2XyYMany(XYZs)
    sz = size(XYZs);
    numCols = sz(2);
    
    for col=1:(numCols)
        
        XYZ = XYZs(:,col);

        X = XYZ(1);
        Y = XYZ(2);
        Z = XYZ(3);

        x = X/(X+Y+Z);

        y = Y/(X+Y+Z);

        xyY = [x,y,Y];
        
        xyYs(:,col) = xyY;
    
    end

end 
