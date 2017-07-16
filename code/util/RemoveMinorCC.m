function Retain_Img = RemoveMinorCC(SegImg,reject_T)
    if nargin < 2      
        reject_T = 0.2;
    end
    Retain_Img = zeros(size(SegImg));
	
    % class 2
    Img_C2 = (SegImg==2);
    Retain_C2 = Connection_Judge_3D(Img_C2,reject_T);
    Retain_C2 = imfill(Retain_C2,'hole');
    Retain_Img(Retain_C2) = 2;
    
    % class 1
    Img_C1 = (SegImg==1);
    Retain_C1 = Connection_Judge_3D(Img_C1,reject_T);
    Retain_C1 = imfill(Retain_C1,'hole');
    Retain_Img(Retain_C1) = 1;
end