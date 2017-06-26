#!/bin/bash

# On MacOS with homebrew:
#   brew install packer
#   brew install ansible

# ******************************************************************************
# VERSION of driver to beat bug
export NVIDIA_DRIVER=381.22
export NVIDIA_DRIVER_MAJOR=381 #

export CUDA_VERSION=8.0.61_375.26
export CUDA_VERSION2=8.0.61-1
export CUDA_DEB=cuda-repo-ubuntu1604_${CUDA_VERSION2}_amd64.deb
export NVIDIA_CUDA_URL_ROOT=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/
export NVIDIA_CUDA_KEY=7fa2af80.pub

export NVIDIA_CUDA_DNN_URL_ROOT=https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/
export CUDNN_VERSION=6.0.21

# ******************************************************************************
# 1. Install latest drivers from Ubuntu PPA for 16.04
# This defeats a bug here: https://bugs.launchpad.net/ubuntu/+source/nvidia-graphics-drivers-375/+bug/1662860
# Use graphics driver: nvidia-378.13  to eliminate libEGL.so.1 is not a symbolic link bug
# see https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa
# could go as high as 381.22
# it is from graphics drivers ppa get with:
add-apt-repository ppa:graphics-drivers/ppa
apt-get update
apt-get install -y --no-install-recommends nvidia-graphics-drivers-${NVIDIA_DRIVER_MAJOR}

# ******************************************************************************
# 2. Get CUDA from NVIDIA Ubuntu 16.04 repository and install dependencies
# install both cuda-repo and cuda-drivers
apt-key adv --fetch-keys ${NVIDIA_CUDA_URL_ROOT}${NVIDIA_CUDA_KEY}
echo "deb ${NVIDIA_CUDA_URL_ROOT} /" > /etc/apt/sources.list.d/cuda.list
apt-get update
apt-get install -y --no-install-recommends cuda-repo
apt-get install -y --no-install-recommends linux-headers-generic dkms cuda-drivers

# ******************************************************************************
# 3. Install CUDA DNN and clear list of packages (This is safe)
apt-get install build-essential cmake git unzip pkg-config
apt-get install libopenblas-dev liblapack-dev
# this is the CUDA Profiler Tools Interface (CUPTI)
apt-get install libcupti-dev
echo "deb ${NVIDIA_CUDA_DNN_URL_ROOT} /" > /etc/apt/sources.list.d/nvidia-ml.list
apt-get update
apt-get install -y --no-install-recommends libcudnn6=$CUDNN_VERSION-1+cuda8.0 && \
rm -rf /var/lib/apt/lists/*

# append environment variables to bash_profile for Ubuntu
echo 'export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"' >> ~/.bash_profile
echo "export CUDA_HOME=/usr/local/cuda" >> ~/.bash_profile
# bring variables into the environment
source ~/.bash_profile
