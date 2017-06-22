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
    
## Test that TensorFlow is actually using GPU

Start a shell watch the GPU as above:

    $ watch -n 1 nvidia-smi
    
Run the following code (e.g in jupyter notebook):

    import tensorflow as tf
    with tf.device('/gpu:0'):
        a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
        b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
        c = tf.matmul(a, b)
        # Creates a session with log_device_placement set to True.
        sess = tf.Session(config=tf.ConfigProto(log_device_placement=True))
        # Runs the op.
        print(sess.run(c))
        
 Observe NVIDIA-SMI output shows something happening:
 
         Every 1.0s: nvidia-smi                                                                                         Thu Jun 22 18:34:16 2017

        Thu Jun 22 18:34:16 2017
        +-----------------------------------------------------------------------------+
        | NVIDIA-SMI 375.66                 Driver Version: 375.66                    |
        |-------------------------------+----------------------+----------------------+
        | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
        | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
        |===============================+======================+======================|
        |   0  Tesla K80           Off  | 0000:00:1E.0     Off |                    0 |
        | N/A   44C    P0   138W / 149W |   8453MiB / 11439MiB |     78%      Default |
        +-------------------------------+----------------------+----------------------+

        +-----------------------------------------------------------------------------+
        | Processes:                                                       GPU Memory |
        |  GPU       PID  Type  Process name                               Usage      |
        |=============================================================================|
        |    0      2641    C   /usr/bin/python                               8451MiB |
        +-----------------------------------------------------------------------------+


