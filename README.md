## DenseVoxNet and 3D-DSN
 * Automatic 3D Cardiovascular MR Segmentation with Densely-Connected Volumetric ConvNets
 * 3D Deeply Supervised Network for Automated Segmentation of Volumetric Medical Images

### Introduction

This repository includes the code (training and testing) for our papers about DenseVoxNet and 3D-DSN. The code is based on 3D-CNN for volumetric segmentation, and the 3D operation is implemented with [3D-Caffe](https://github.com/yulequan/3D-Caffe) library. You can simply extend this code to other volumetric segmentation tasks.

### Installation

1. Follow the instruction of [3D-Caffe](https://github.com/yulequan/3D-Caffe#installation) to install Caffe library.

2. Also use ```make matcaffe``` to build Matlab interface. 

3. Install Matlab toolbox [NIfTI_tools](https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image) in order to read nii data format in Matlab.

### Usage

1. Download [HVSMR](http://segchd.csail.mit.edu/data.html) dataset (phase 2) and put them in folder ``data``.

2. Prepare the hdf5 data to train the model.
  ```shell
  cd code
  #modify parameters in prepare_h5_data.m file
  matlab prepare_h5_data.m
  ```
3. Train the model
  ```shell
  cd DenseVoxNet or cd 3D-DSN # Different folder for different network architecture
  sh start_train.sh
  ```
4. Test the model
  ```shell
  cd code
  #modify parameters and model path in test_model.m
  matlab test_model.m
  ```
### Note
- We use **HDF5DataLayer** to read data. You need to generate the hdf5 data from original data type. See ``prepare_h5_data.m`` for more details.

- Due to the limited GPU memory, we use patch-based training/testing strategy. The patch size is 64*64*64. You can modify it in network architecture and corresponding .m file.

- In order to get the whole prediction, we provided two schemes (average fusion and major voting). Please see paper for more details.

- Generally, the batch normalization will accerate the training. We had better set the batch size (>1) to properly use batchnorm.

### Citation
If you find this code is useful for your research, pleae consider citing:
  
  @article{yu2017automatic,
    author={Yu, Lequan and Cheng,Jie-Zhi and Dou, Qi and Yang, Xin and Chen, Hao and Qin, Jing and Heng, Pheng-Ann},
    title={Automatic 3D Cardiovascular MR Segmentation with Densely-Connected Volumetric ConvNets},
    Journal={MICCAI},
    year={2017}
  }
  
and/or

  @article{dou20173d,
    author={Dou, Qi and Yu, Lequan and Chen, Hao and Jin, Yueming and Yang, Xin and Qin, Jing and Heng, Pheng-Ann},
    title={3D deeply supervised network for automated segmentation of volumetric medical images},
    journal={Medical Image Analysis},
    publisher={Elsevier},
    year={2017}
  }

###Questions

Please contact 'ylqzd2011@gmail.com' or 'lqyu@cse.cuhk.edu.hk'
