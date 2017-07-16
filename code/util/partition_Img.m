function [patch_list, r, c, h] = partition_Img(srcImg, patchSize, ita)
    [r, c, h] = size(srcImg);
    
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
    fprintf('%d, %d,%d\n',r_ovlap,c_ovlap,h_ovlap);
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
                patch_list{p_count} = srcImg(r_s:r_e, c_s:c_e, h_s:h_e);
                p_count = p_count + 1;
            end
        end 
    end
end
