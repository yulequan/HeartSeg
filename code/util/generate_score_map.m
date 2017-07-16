function score_map = generate_score_map(net, img,patchSize,ita,level)
    %% set parameter
    tr_mean = 0;
    
    %pad the img if the size is smaller than the crop size
    pading_size = max(0,ceil((64-size(img))/2));
    img = padarray(img,pading_size);
    
    data = img-tr_mean;
    score = zeros([size(img),3]);
    cnt   = zeros([size(img)]);
    ss    = size(img);
    fold  = floor(ss/patchSize) +ita;
    overlap = ceil((ss-patchSize)./(fold-1));
    idx_h = [1:overlap(1):ss(1)-patchSize+1,ss(1)-patchSize+1];
    idx_w = [1:overlap(2):ss(2)-patchSize+1,ss(2)-patchSize+1];
    idx_l = [1:overlap(3):ss(3)-patchSize+1,ss(3)-patchSize+1];

    for itr_h = idx_h
        for itr_w = idx_w
            for itr_l = idx_l
                 crop_data = data(itr_h:itr_h+patchSize-1,itr_w:itr_w+patchSize-1,itr_l:itr_l+patchSize-1);
                 res = net.forward({single(crop_data)});
                 res_score = res{level};
                 cnt(itr_h:itr_h+patchSize-1,itr_w:itr_w+patchSize-1,itr_l:itr_l+patchSize-1) = ...
                     cnt(itr_h:itr_h+patchSize-1,itr_w:itr_w+patchSize-1,itr_l:itr_l+patchSize-1) + 1;
                 score(itr_h:itr_h+patchSize-1,itr_w:itr_w+patchSize-1,itr_l:itr_l+patchSize-1,:) = ...
                     score(itr_h:itr_h+patchSize-1,itr_w:itr_w+patchSize-1,itr_l:itr_l+patchSize-1,:) + res_score;
            end
        end
    end
    score_map = score ./repmat(cnt,1,1,1,3);
    
    %remove the margin of padding
    p1 = pading_size(1);
    p2 = pading_size(2);
    p3 = pading_size(3);
    score_map = score_map(p1+1:end-p1, p2+1:end-p2,p3+1:end-p3,:);
end