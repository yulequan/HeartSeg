LOGDIR=./training_log
CAFFE=../3D-Caffe/build/tools/caffe
SOLVER=./solver.prototxt
mkdir snapshot
mkdir $LOGDIR

GLOG_log_dir=$LOGDIR $CAFFE train -solver $SOLVER -gpu 0

