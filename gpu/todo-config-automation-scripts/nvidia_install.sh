#!/bin/bash

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
# Install latest drivers from Ubuntu PPA for 16.04
# This defeats a bug here: https://bugs.launchpad.net/ubuntu/+source/nvidia-graphics-drivers-375/+bug/1662860
# Use graphics driver: nvidia-378.13  to eliminate libEGL.so.1 is not a symbolic link bug
# see https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa
# could go as high as 381.22
# it is from graphics drivers ppa get with:
add-apt-repository ppa:graphics-drivers/ppa
apt-get update
apt-get install -y --no-install-recommends nvidia-graphics-drivers-${NVIDIA_DRIVER_MAJOR}

# Get CUDA from NVIDIA Ubuntu 16.04 repository and install dependencies
# install both cuda-repo and cuda-drivers
apt-key adv --fetch-keys ${NVIDIA_CUDA_URL_ROOT}${NVIDIA_CUDA_KEY}
echo "deb ${NVIDIA_CUDA_URL_ROOT} /" > /etc/apt/sources.list.d/cuda.list
apt-get install -y --no-install-recommends cuda-repo
apt-get install -y --no-install-recommends linux-headers-generic dkms cuda-drivers

# Install CUDA DNN and clear list of packages (This is safe)
echo "deb ${NVIDIA_CUDA_DNN_URL_ROOT} /" > /etc/apt/sources.list.d/nvidia-ml.list
apt-get install -y --no-install-recommends libcudnn6=$CUDNN_VERSION-1+cuda8.0 && \
rm -rf /var/lib/apt/lists/*