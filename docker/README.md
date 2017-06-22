# Useful commands for working with Docker.

This document, in progress, is a cleaner, updated version of [old notes on interacting with Docker](https://docs.google.com/document/d/1LOHzfwGZiXtuqyZkcBREHHa0-0c853qaFAgQ-X8pqlE/edit?usp=sharing).

**NOTE: We typically use NVIDIA Docker, which just means replace `docker` with `nvidia-docker` in commands below.**

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
