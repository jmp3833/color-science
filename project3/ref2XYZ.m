function xyz = ref2XYZ( ref, cmf, illum )
    k = 100 / sum( illum.* cmf(:,2).* 10 );
    
    x = k.* sum(cmf(:,1).* illum.* ref.* 10);
    y = k.* sum(cmf(:,2).* illum.* ref.* 10);
    z = k.* sum(cmf(:,3).* illum.* ref.* 10);
    
    xyz = [x,y,z];
end