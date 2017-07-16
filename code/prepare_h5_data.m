function []= prepare_h5_data(data_folder, h5_save_folder,h5_save_list)
% Generate the hdf5 file and a file list used to train the network
% --------------------------------------------------------
% Copyright (c) 2017, Lequan Yu
% Licensed under The MIT License
% --------------------------------------------------------

    % re-sample the data into same resolution, default is False.
    use_isotropic=0;
    patchSize = 64;
    if nargin<3
        data_folder = '../data';
        h5_save_folder = '../h5_data';
        h5_save_list = '../train.list';

    if ~exist(h5_save_folder,'dir')
        mkdir(h5_save_folder);
    end

    addpath('./util');
    fid = fopen(h5_save_list, 'w');

    %% generate the hdf5 file
    for id = 0:0
        tic;
        img_path = [data_folder, '/', 'training_axial_crop_pat', num2str(id), '.nii.gz'];
        seg_path = [data_folder, '/', 'training_axial_crop_pat', num2str(id), '-label.nii.gz'];

        img_nii = load_nii(img_path);
        seg_nii = load_nii(seg_path); 

        %pre-process the images (intensity and resize)
        [img,seg] = pre_process_isotropic(img_nii,seg_nii,use_isotropic,id); 

        % crop the heart patches (ROI) from whole image and randomly crop patches
        [img,seg,rimgs,rsegs] = Create_ROIs(img, seg,patchSize);

        %% Do data augmentation (permute & rotate & flip)
        % We only do augmentation at axial plane
        % You can do agumentation in all three planes by setting it_p = 1:3
        pp= [1 2 3; 2 3 1; 3 1 2];
        for it_p = 1:1
            permute_img = permute(img,pp(it_p,:));
            permute_seg = permute(seg,pp(it_p,:));
            for it_r = 1:4
                % rotate
                rotate_img = rot90(permute_img, it_r - 1);
                rotate_seg  = rot90(permute_seg, it_r - 1);
                % flip
                for it_f = 0:1
                    if it_f == 0
                        flip_img = rotate_img;
                        flip_seg = rotate_seg;              
                    else
                        flip_img = flip(rotate_img, it_f);
                        flip_seg = flip(rotate_seg, it_f);
                    end

                    % h5 file path
                    h5_path    = [h5_save_folder, '/', num2str(id), '_p', num2str(it_p),...
                        '_r', num2str(it_r), 'f', num2str(it_f), '.h5'];
                    if exist(h5_path,'file')
                        delete(h5_path);
                    end

                    [d1, d2, d3, d4, d5] = size(flip_img);
                    data_dims = [d1, d2, d3, d4, d5];
                    [d1, d2, d3, d4, d5] = size(flip_seg);
                    seg_dims = [d1, d2, d3, d4, d5];

                    % store as h5 format
                    h5create(h5_path,'/data',data_dims,'Datatype','single','Deflate',0,'ChunkSize',data_dims);
                    h5create(h5_path,'/label',seg_dims,'Datatype','uint8','Deflate',0,'ChunkSize',seg_dims);
                    h5write(h5_path,'/data', single(flip_img));
                    h5write(h5_path,'/label',uint8(flip_seg));
                    fprintf(fid,'%s\n', h5_path);
                end
            end
        end

        %% save randomly cropped patches.
        % Default, we do not use them to train the model
        for i= 1: 0 %size(random_img, 5)
            h5_path  = [h5_save_folder, '/',num2str(id), '_random_', num2str(i), '.h5'];
            if exist(h5_path,'file')
                delete(h5_path);
            end

            write_img = rimgs{i};
            write_seg  = rsegs{i};
            [d1, d2, d3, d4, d5] = size(write_img);
            data_dims = [d1, d2, d3, d4, d5];
            [d1, d2, d3, d4, d5] = size(write_seg);
            seg_dims = [d1, d2, d3, d4, d5];

            % store as h5 format
            h5create(h5_path,'/data',data_dims,'Datatype','single','Deflate',0,'ChunkSize',data_dims);
            h5create(h5_path,'/label',seg_dims,'Datatype','uint8','Deflate',0,'ChunkSize',seg_dims);
            h5write(h5_path,'/data', single(write_img));
            h5write(h5_path,'/label',uint8(write_seg));
            fprintf(fid,'%s\n', h5_path);
        end
        toc;
    end
    fclose(fid);
end
