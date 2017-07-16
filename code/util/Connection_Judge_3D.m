function Connect_Elimi = Connection_Judge_3D(Binary_Img, reject_T)
    Connect_Elimi = Binary_Img;  
    % find components  
    CC = bwconncomp(Binary_Img);
    % component number  
    C_number = CC.NumObjects;  
    % pixel number  
    numPixels = cellfun(@numel, CC.PixelIdxList);  
    totalPixels_N = sum(numPixels);  
    % remove minor components  
    for k = 1:C_number  
        cPixel_N = length( CC.PixelIdxList{k} );  
        ratio = cPixel_N / totalPixels_N;  
        if ratio  < reject_T
            Connect_Elimi(CC.PixelIdxList{k}) = 0;
        end  
    end
end
