% Calculate xyz values for a single reference factor
% With given cmf and illumination colum vectors. 

%This can be used in conjunction with CalcXYZS to calculate a series of XYZ
%values at once using an iterator. 
function xyz = ref2XYZ( ref, cmf, illum )
    k = 100 / sum( illum.* cmf(:,2).* 10 );
    
    x = k.* sum(cmf(:,1).* illum.* ref.* 10);
    y = k.* sum(cmf(:,2).* illum.* ref.* 10);
    z = k.* sum(cmf(:,3).* illum.* ref.* 10);
    
    xyz = [x,y,z];
end