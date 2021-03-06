function [ M_fwd ] = derive_fwd_matrix(MAX_XYZS, BLACK_XYZS, WHITE_XYZS)
  
  red = (MAX_XYZS(1,:) - BLACK_XYZS)';
  green = (MAX_XYZS(2,:) - BLACK_XYZS)';
  blue = (MAX_XYZS(3,:) - BLACK_XYZS)';
  
  M_fwd = [red green blue BLACK_XYZS'] ./ WHITE_XYZS(:,2);
end

