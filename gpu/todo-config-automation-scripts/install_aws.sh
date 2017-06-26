#!/bin/bash

# set up linux headers and files for AMS

set -eux

apt-get update
apt-get install -y linux-aws linux-headers-aws linux-image-aws
