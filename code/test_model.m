% Script to test the model
% --------------------------------------------------------
% Copyright (c) 2017, Lequan Yu
% Licensed under The MIT License
% --------------------------------------------------------

close all; clear all; clc;
% add matcaffe path
addpath(genpath('../3D-Caffe/matlab/'));
% parameters
use_isotropic = 0;
patchSize = 64;
ita = 4;
level = 1;
tr_mean = 0;

% set model path 
addpath('./util');
model_folder = '../DenseVoxNet/'
model   = [model_folder, 'deploy.prototxt'];
weights = [model_folder, 'snapshot/HVSMR_iter_15000.caffemodel'];

% set save path
root_folder = '../data/';
result_folder = '../result/';
if ~exist(result_folder,'dir')
    mkdir(result_folder);
end
if ~exist([result_folder 'avg/'],'dir')
    mkdir([result_folder 'avg/']);
end
if ~exist([result_folder 'voting/'],'dir')
    mkdir([result_folder 'voting/']);
end
%prediction
caffe.reset_all
caffe.set_mode_gpu()
caffe.set_device(0)
net = caffe.Net(model, weights, 'test');    

for id = 0:0
    %% read data and preprocessing
    tic;
    fprintf('test sample #%d\n',id)
    pred_list = [];
    vol_path = [root_folder, 'training_axial_crop_pat' num2str(id) '.nii.gz'];
    vol_src = load_nii(vol_path);
    vol_data = pre_process_isotropic(vol_src,[],use_isotropic,id);
    data = vol_data - tr_mean;
    
    %% average fusion scheme
    score_map = generate_score_map(net, data, patchSize, ita,level);
    [~,res_label] = max(score_map,[],4);
    avg_label = res_label -1;
    %avg_label = GetLabelfromScore(score_map);
    toc;
    %% major voting scheme
    [patch_list, r, c, h] = partition_Img(data, patchSize, ita);
	for k = 1 : length(patch_list)
        crop_data = patch_list{k};
        res = net.forward({crop_data});
        res_L2 = res{level};
        %res_label = GetLabelfromScore(res_L2);
        [~,res_label] = max(res_L2,[],4);
        pred_list{k} = res_label-1;
    end
    [fusion_Img_L2, vote_label] = patches2Img_vote(pred_list, r, c, h, patchSize, ita); 
    
    %% post-processing
    if use_isotropic == 1
        vote_label = imresize3d(vote_label,[],vol_src.hdr.dime.dim(2:4),'nearest','bound');
        avg_label = imresize3d(avg_label,[],vol_src.hdr.dime.dim(2:4),'nearest','bound');
    end
    
    % remove minor connected components
    vote_label = RemoveMinorCC(vote_label,0.2);
    avg_label = RemoveMinorCC(avg_label,0.2);
    
    %% save with original header info.
    img_src = load_untouch_nii(vol_path);
    vote_label = permute(vote_label, [2 3 1]);
    vote_label = rot90(vote_label, 2);      
 	img_src.img = uint16(vote_label);
    save_name = [result_folder, 'voting/training_axial_crop_pat', num2str(id), '-label.nii.gz'];
    save_untouch_nii(img_src, save_name);

    avg_label = permute(avg_label, [2 3 1]);
    avg_label = rot90(avg_label, 2);
    img_src.img = uint16(avg_label);
    save_name = [result_folder, 'avg/training_axial_crop_pat', num2str(id), '-label.nii.gz'];
    save_untouch_nii(img_src, save_name);
    toc;
end
caffe.reset_all;

