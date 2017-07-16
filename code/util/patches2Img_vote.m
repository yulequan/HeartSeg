function [fusion_Img, vote_Img] = patches2Img_vote(patch_list, r, c, h, patchSize, ita)
    fusion_Img = zeros(r, c, h);
    label_0_mat = zeros(r, c, h);
    label_1_mat = zeros(r, c, h);
    label_2_mat = zeros(r, c, h);
    label_mat = zeros(r, c, h, 3);
    
    % patch number and overlap in first dimension
    r_fold = int16(r)/int16(patchSize);
    r_mod = mod(r, patchSize);
    r_fold = r_fold + ita;
%     if r_mod > 0
%         r_fold = r_fold + ita;
%     end
    r_ovlap = ceil((double(r_fold)*patchSize - r)/(double(r_fold)-1));
    
    % patch number and overlap in second dimension
    c_fold = int16(c)/int16(patchSize);
    c_mod = mod(c, patchSize);
    c_fold = c_fold + ita;
%     if c_mod > 0
%         c_fold = c_fold + ita;
%     end
    c_ovlap = ceil((double(c_fold)*patchSize - c)/(double(c_fold)-1));
    
    % patch number and overlap in third dimension
    h_fold = int16(h)/int16(patchSize);
    h_mod = mod(h, patchSize);
    h_fold = h_fold + ita;
%     if h_mod > 0
%         h_fold = h_fold + ita;
%     end
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
                % histogram for voting
                idx_0 = double((patch_list{p_count}==0));
                idx_1 = double((patch_list{p_count}==1));
                idx_2 = double((patch_list{p_count}==2));
                label_0_mat(r_s:r_e, c_s:c_e, h_s:h_e) = label_0_mat(r_s:r_e, c_s:c_e, h_s:h_e) + idx_0;
                label_1_mat(r_s:r_e, c_s:c_e, h_s:h_e) = label_1_mat(r_s:r_e, c_s:c_e, h_s:h_e) + idx_1;
                label_2_mat(r_s:r_e, c_s:c_e, h_s:h_e) = label_2_mat(r_s:r_e, c_s:c_e, h_s:h_e) + idx_2;
                
                p_count = p_count + 1;
            end
        end 
    end
    
    label_mat(:,:,:,1) = label_0_mat;
    label_mat(:,:,:,2) = label_1_mat;
    label_mat(:,:,:,3) = label_2_mat;
    
%     label_Mat = cat(3, label_0_mat, label_1_mat, label_2_mat);
    [~,vote_label] = max(label_mat, [], 4);
    vote_Img = vote_label -1;
end