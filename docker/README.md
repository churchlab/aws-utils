# Useful commands for working with Docker.

This document, in progress, is a cleaner, updated version of [old notes on interacting with Docker](https://docs.google.com/document/d/1LOHzfwGZiXtuqyZkcBREHHa0-0c853qaFAgQ-X8pqlE/edit?usp=sharing).

**NOTE: We typically use NVIDIA Docker, which just means replace `docker` with `nvidia-docker` in commands below.**

## Install and Config

Installation instructions:

https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/

Don't require sudo for docker (https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo):

    $ sudo usermod -aG docker $USER

## Common commands

List running containers (from host machine shell)

    $ docker ps

Example output:

    CONTAINER ID        IMAGE                                     COMMAND                  CREATED             STATUS              PORTS                              NAMES
    d128fd2ab466        gcr.io/tensorflow/tensorflow:latest-gpu   "/run_jupyter.sh -..."   2 minutes ago       Up 2 minutes        6006/tcp, 0.0.0.0:8888->8888/tcp   eager_newton

Connect ("ssh") to running docker container using its name (following example above):

    $ docker exec -i -t eager_newton /bin/bash

Start docker container with directory from host drive mounted. This is useful so
that data isn't wiped upon turning off docker. The following command assumes your
Github repos are in a directory on host called `~/notebooks`:

    $ nvidia-docker run -it -p 8888:8888 -v ~/notebooks:/notebooks gcr.io/tensorflow/tensorflow:latest-gpu
    
## Cleanup

Sometimes your host machine can fill up with Docker cruft and you need to delete things. I'm not familiar enough with Docker quiet yet, but here are some commands that might be useful, based on <https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430> and [this Stackoverflow](https://stackoverflow.com/questions/21398087/how-can-i-delete-dockers-images).

This command will delete any docker containers:

    $ docker rm $(docker ps -a -q)

Delete intermediate images created by Docker for optimization purposes:

    $ docker rmi $(docker images | grep "none" | awk '/ / { print $3 }')
    
Or you can delete all images:

    $ docker rmi $(docker images -q)
