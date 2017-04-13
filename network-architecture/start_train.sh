#export LD_LIBRARY_PATH=/usr/local/cuda/lib64
LOGDIR=./training_log
CAFFE=../caffe/build/tools/caffe
SOLVER=./solver.prototxt
mkdir snapshot
mkdir $LOGDIR

GLOG_log_dir=$LOGDIR $CAFFE train -solver $SOLVER -gpu 0


