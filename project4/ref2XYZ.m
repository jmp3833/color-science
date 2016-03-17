%% ref2XYZ Function
function XYZ = ref2XYZ(ref,cmfs,ill)
    % compute XYZ from surface reflectance factor(s), color matching functions,
    % and illuminant spectral power distribution
    % can handle multiple ref(s) simultaneously
    % 3/9/16 jaf
    %compute normalizing constant for each illuminant
    k = 100./(cmfs(:,2)'*ill);
    %compute XYZ
    XYZ = k.*cmfs'*diag(ill)*ref;
    % % alternate calculation method that doesn't use diag
    % ill_array = repmat(ill,[1,size(ref,2)]);
    % XYZ = k.*cmfs'*(ref.*ill_array);