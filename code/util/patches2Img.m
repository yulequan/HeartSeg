function fusion_Img = patches2Img(patch_list, r, c, h, patchSize)
    fusion_Img = zeros(r, c, h);
    
    % patch number and overlap in first dimension
    r_fold = int16(r)/int16(patchSize);
    r_mod = mod(r, patchSize);
    if r_mod > 0
        r_fold = r_fold + 1;
    end
    r_ovlap = ceil((double(r_fold)*patchSize - r)/(double(r_fold)-1));
    
    % patch number and overlap in second dimension
    c_fold = int16(c)/int16(patchSize);
    c_mod = mod(c, patchSize);
    if c_mod > 0
        c_fold = c_fold + 1;
    end
    c_ovlap = ceil((double(c_fold)*patchSize - c)/(double(c_fold)-1));
    
    % patch number and overlap in third dimension
    h_fold = int16(h)/int16(patchSize);
    h_mod = mod(h, patchSize);
    if h_mod > 0
        h_fold = h_fold + 1;
    end
    h_ovlap = ceil((double(h_fold)*patchSize - h)/(double(h_fold)-1));
    
    % partition into patches
    p_count = 1;
    for R = 1:r_fold
        r_s = (R - 1)*patchSize + 1 - (R - 1)*r_ovlap;
        r_e = r_s + patchSize - 1;
        for C = 1:c_fold
            c_s = (C - 1)*patchSize + 1 - (C - 1)*c_ovlap;
            c_e = c_s + patchSize - 1;
            for H = 1:h_fold
                h_s = (H - 1)*patchSize + 1 - (H - 1)*h_ovlap;
                h_e = h_s + patchSize - 1;
                % partition
%                 fprintf('r_e = %d, c_e = %d, h_e = %d\n', r_e, c_e, h_e);
                fusion_Img(r_s:r_e, c_s:c_e, h_s:h_e) = patch_list{p_count};
                p_count = p_count + 1;
            end
        end 
    end
end