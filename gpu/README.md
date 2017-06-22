# Configuring / using GPU machines with AWS

*NOTE: These docs are still in progress as we figure this out.*

## Our AMI with nvidia-docker

I setup an AMI with the latest nvidia drivers (375) and nvidia-docker:

    GK_2017_06_21_nvidia-driver-375-docker-nvidia-docker (ami-a4a48db2)

To use:

1. Launch a GPU instance from that AMI.

2. Connect with port-forwarding

        $ ssh -i ~/.ssh/mlpe-common.pem -L 8888:localhost:8888 ubuntu@ec2-xxxxxxxxxxx.compute-1.amazonaws.com

2. Start screen or tmux so you can have multiple shells.

3. Boot up a Docker container with the latest tensorflow config using:

        $ nvidia-docker run -it -p 8888:8888 gcr.io/tensorflow/tensorflow:latest-gpu

There will be a delay as the docker downloads the image (first time only). Then Jupyter Notebook will automatically be started. You should see the familiar console output.

See [notes for working with Docker](../docker/README.md).

## Inspecting GPU usage

It is pretty common when getting started to find that you are not actually using the GPU.

The following command takes a snapshot of Nvidia state every second. If GPU is actually being used, you should see the memory and processor filling up:

    $ watch -n 1 nvidia-smi
