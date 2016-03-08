function xyz = ref2XYZ( ref, cmf, illum )
%REF2XYZ Summary of this function goes here
%Detailed explanation goes here
    ks = 100 / sum( illum.* cmf(:,2) );
    xyz = ks * cmf' * diag(illum) * ref';
end