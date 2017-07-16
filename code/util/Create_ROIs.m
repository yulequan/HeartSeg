function [new_img,new_seg,rimgs,rsegs] = Create_ROIs(img, seg,patchSize)
% Create the ROIs needed, x*y*z
% Also randomly crop patches to increase background information
% -------------------------------------------------------------
    % the agumented size of surrounding context
    aug_r =20;
    
    img = single(img);
    
    % get bounding box
    [s1, s2, s3] = size(seg);
    positions = regionprops(seg>0, 'BoundingBox');
    position  = positions(1).BoundingBox;
    cx = max(ceil(position(1)) - aug_r/2, 1);
    cy = max(ceil(position(2)) - aug_r/2, 1);
    cz = max(ceil(position(3)) - aug_r/2, 1); 
    x  = min(ceil(position(4)) + aug_r, s2 - cx + 1);
    y  = min(ceil(position(5)) + aug_r, s1 - cy + 1);
    z  = min(ceil(position(6)) + aug_r, s3 - cz + 1);
    
    % crop ROI
    new_img = img(cy:cy+y-1, cx:cx+x-1, cz:cz+z-1, :);
    new_seg = seg(cy:cy+y-1, cx:cx+x-1, cz:cz+z-1);

    % padding the ROI to patchSize*patchSize*patchSize 
    pading_size = max(0, ceil((patchSize-size(img))/2));
    new_img = padarray(new_img,pading_size);
    new_seg = padarray(new_seg,pading_size,100);
    
    % randomly crop patches from the whole volume 
    rimgs = [];
    rsegs  = [];
    for k = 0: 0
        [sy, sx, sz] = size(img);
        cy = floor(rand()*(sy -y)+1);
        cx = floor(rand()*(sx -x)+1);
        cz = max(floor(rand()*(sz - z+1)), 1);
        random_per_imgs = img(cy:cy+y-1, cx:cx+x-1, cz:cz+z-1,:);
        random_per_seg1 = seg(cy:cy+y-1, cx:cx+x-1, cz:cz+z-1);
        rimgs{end+1}  = random_per_imgs;
        rsegs{end+1} = random_per_seg1;
    end
end
