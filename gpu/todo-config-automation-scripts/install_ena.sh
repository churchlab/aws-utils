#!/bin/bash

set -eux

apt-get update
apt-get install -y linux-aws linux-headers-aws linux-image-aws
