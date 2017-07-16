function [img,seg] = pre_process_isotropic(img_nii,seg_nii,use_isotropic,id)
% Pre-process the data
% Normalize the intensity of the images and also do some re-sample.
%
% If use_isotropic is True, we will resize all samples to same resolution,
% otherwise, we will only resize the sample 4 and 5 (which have much low 
% resolution than other samples)
%------------------------------------------------------------------------

    if nargin <4
        id = 1;
    end
    
    if use_isotropic
        scale = img_nii.hdr.dime.pixdim(2:4)./[0.80 0.7588 0.7588];
        new_size = round(img_nii.hdr.dime.dim(2:4).*scale);
        img = imresize3d(img_nii.img,[],new_size,'cubic','bound');
        if ~isempty(seg_nii)
            seg = imresize3d(seg_nii.img,[],new_size,'nearest','bound');
        end
    else
        if id==4 || id==5
            % resize img in up and down plane
            img = permute(img_nii.img,[3,2,1]);
            img = imresize(img,1.5,'bilinear');
            img = permute(img,[3,2,1]);
            if ~isempty(seg_nii)
                seg = permute(seg_nii.img,[3,2,1]);
                seg = imresize(seg,1.5,'nearest');
                seg = permute(seg,[3,2,1]);
            end
        else
            img = img_nii.img;
            if ~isempty(seg_nii)
                seg = seg_nii.img;
            end
        end
    end
    
    %Normalize the intensity of images
    img = single(img);
    mask = img>0;
    mean_value = mean(img(mask));
    std_value  = std(img(mask),1);
    img = bsxfun(@rdivide, bsxfun(@minus, img, mean_value), std_value);
end
