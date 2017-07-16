function label = GetLabelfromScore(score_map)
    [value,idx] = sort(score_map,4,'descend');
    label = idx(:,:,:,1)-1;
end